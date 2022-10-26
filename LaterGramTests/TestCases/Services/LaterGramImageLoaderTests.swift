//
//  LaterGramLoaderTests.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 20/10/2022.
//

import XCTest
import LaterGram

final class LaterGramLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestData(){
        let (_, client) = makeSUT(url: url())
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromAGivenURL() {
        let givenURL = url("https://very-secure-url.com")
        
        let (sut, client) = makeSUT(url: givenURL)
        
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs, [givenURL])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = url()
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT(url: url())
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Tests", code: 0)
            client.completes(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200StatusCode() {
        let (sut, client) = makeSUT(url: url())
        
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeItemsJSON([])
                client.completes(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT(url: url())
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("Invalid json".utf8)
            client.completes(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyList() {
        let (sut, client) = makeSUT(url: url())
        
        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeItemsJSON([])
            client.completes(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT(url: url())
        
        let item1 = makeImageItem(id: "8989839", type: "IMAGE", url: url(), username: "super-user", timestamp: (Date(timeIntervalSince1970: 1657127177), "2022-07-06T17:06:17+00:00"))
        
        let item2 = makeImageItem(id: "9989839", type: "CAROUSEL_ALBUM", url: url(), username: "super-user", timestamp: (Date(timeIntervalSince1970: 1657127030), "2022-07-06T17:03:50+00:00"))
        
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemsJSON([item1.json, item2.json])
            client.completes(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_doesNotDeliverResultsAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: LaterGramLoader? = RemoteLaterGramLoader(url: url(), client: client)
        
        var capturedResults = [LaterGramLoader.Result]()
        sut?.load { capturedResults.append($0)}
        
        sut = nil
        client.completes(withStatusCode: 200, data: makeItemsJSON([]))
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL) -> (sut: RemoteLaterGramLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLaterGramLoader(url: url, client: client)
        
        return (sut, client)
    }
    
    
    private func expect(_ sut: RemoteLaterGramLoader, toCompleteWith expectedResult: RemoteLaterGramLoader.Result,
                        when action: () -> Void, file: StaticString = #filePath,
                        line: UInt = #line) {
        let exp = expectation(description: "wait for load completion")
        sut.load { receivedResult in
            switch(receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteLaterGramLoader.Error), .failure(expectedError as RemoteLaterGramLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), received \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }

    private func failure(_ error: RemoteLaterGramLoader.Error) -> LaterGramLoader.Result {
        .failure(error)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["data": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeImageItem(id: String, type: String, url: URL, username: String, timestamp: (date: Date, iso8601String: String)) -> (model: ImageItem, json: [String: Any]) {
        let item = ImageItem(id: id, type: type, url: url, username: username, timestamp: timestamp.date)
        
        let json = [
            "id": id,
            "media_type": type,
            "media_url": url.absoluteString,
            "username": username,
            "timestamp": timestamp.iso8601String
        ]
        
        return (item, json)
    }
}
