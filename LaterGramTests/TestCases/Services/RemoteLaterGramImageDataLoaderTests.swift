//
//  RemoteLaterGramImageDataLoaderTests.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 09/11/2022.
//

import XCTest
import LaterGram

final class RemoteLaterGramImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformGETRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsDataFromURL() {
        let url = url("http://some-url.com")
        let (sut, client) = makeSUT(url: url)
        
        _ = sut.loadImageData(from: url){ _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadImageDataFromURLTwice_requestsDataFromURLTwice() {
        let url = url("http://some-funny-url.com")
        let (sut, client) = makeSUT(url: url)
        
        _ = sut.loadImageData(from: url) { _ in }
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_loadImageDataFromURL_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        let clientError = NSError(domain: "😭", code: 1)
        
        expect(sut, toCompleteWith: failure(.connectivity), when:  {
            client.complete(with: clientError)
        })
    }
    
    func test_loadImageDataFromURL_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let sampleStatusCodes = [199, 201, 222, 300, 500]
        sampleStatusCodes.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                client.complete(withStatusCode: code, data: anyData(), at: index)
            })
        }
    }
    
    func test_loadImageDataFromURL_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWith: failure(.invalidData), when:  {
            let emptyData = Data()
            client.complete(withStatusCode: 200, data: emptyData)
        })
    }
    
    func test_loadImageDataFromURL_deliversReceivedNonEmptyDataOn200HTTPResponse() {
        let (sut, client) = makeSUT()
        let anyData = anyData()
        
        expect(sut, toCompleteWith: .success(anyData), when: {
            client.complete(withStatusCode: 200, data: anyData)
        })
    }
    
    func test_cancelLoadImageDataURLTask_cancelsClientURLRequest() {
        let (sut, client) = makeSUT()
        let url = url()
        
        let task = sut.loadImageData(from: url) { _ in }
        XCTAssertTrue(client.cancelledURLs.isEmpty, "No task has been cancelled yet")
        task.cancel()
        XCTAssertEqual(client.cancelledURLs, [url], "A task has been cancelled")
    }
    
    func test_loadImageDataFromURL_doesNotDeliverResultAfterCancellingTask() {
        let (sut, client) = makeSUT()
        let nonEmptyData = anyData("not so empty")
        
        var received = [RemoteLaterGramImageDataLoader.Result]()
        let task = sut.loadImageData(from: url(), completion: { received.append($0)})
        task.cancel()
        
        client.complete(withStatusCode: 404, data: anyData())
        client.complete(withStatusCode: 200, data: nonEmptyData)
        client.complete(with: anyNSError())
        
        XCTAssertTrue(received.isEmpty, "No results should be delivered after cancelling a task")
    }
    
    func test_loadImageDataFromURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = LGHTTPClientSpy()
        var sut: RemoteLaterGramImageDataLoader? = RemoteLaterGramImageDataLoader(client: client)
        
        var capturedResults = [LaterGramImageDataLoader.Result]()
        _ = sut?.loadImageData(from: url()) { capturedResults.append($0)}
        
        sut = nil
        client.complete(withStatusCode: 200, data: anyData())
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    
    // MARK: - Helpers
    private func makeSUT(url: URL = url(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteLaterGramImageDataLoader, client: LGHTTPClientSpy) {
        let client = LGHTTPClientSpy()
        let sut = RemoteLaterGramImageDataLoader(client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteLaterGramImageDataLoader, toCompleteWith expectedResult: LaterGramImageDataLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let url = url()
        let exp = expectation(description: "wait for load completion")
        
        _ = sut.loadImageData(from: url, completion: { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case let (.failure(receivedError as RemoteLaterGramImageDataLoader.Error), .failure(expectedError as RemoteLaterGramImageDataLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        })
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failure( _ error: RemoteLaterGramImageDataLoader.Error) -> LaterGramImageDataLoader.Result {
        return .failure(error)
    }
}
