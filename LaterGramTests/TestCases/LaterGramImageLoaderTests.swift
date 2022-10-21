//
//  LaterGramImageLoaderTests.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 20/10/2022.
//

import XCTest

enum LoadImageResult {
    case success([ImageItem])
    case failure(Error)
}

enum MediaType: String {
    case image = "IMAGE"
    case carousel_album = "CAROUSEL_ALBUM"
    case video = "VIDEO"
}

struct ImageItem: Equatable {
    let id: String
    let type: String
    let url: URL
    let username: String
    let timestamp: Date
    
    public init(id: String, type: String, url: URL, username: String, timestamp: Date) {
        self.id = id
        self.type = type
        self.url = url
        self.username = username
        self.timestamp = timestamp
    }
}

class LaterGramImageLoader {
    let url: URL
    let client: HTTPClient
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadImageResult
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping(Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                completion(GramItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

final class GramItemsMapper {
    private struct Root: Decodable {
        let data: [Item]
        
        var items: [ImageItem] {
            return data.map { $0.image }
        }
    }
    
    /// Internal type matching the API response
    ///  In the event that the API response change, the internal representation will not be affected
    private struct Item: Decodable {
        let id: String
        let media_type: String
        let media_url: URL
        let username: String
        let timestamp: Date
        
        var image: ImageItem {
            return ImageItem(id: id,
                             type: media_type,
                             url: media_url,
                             username: username,
                             timestamp: timestamp
            )
        }
    }
    
    private static var OK_200: Int {
        return 200
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> LaterGramImageLoader.Result {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard response.statusCode == OK_200,
                let root = try? decoder.decode(Root.self, from: data) else {
            return .failure(LaterGramImageLoader.Error.invalidData)
        }
        
        return .success(root.items)
    }
}

enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

final class LaterGramImageLoaderTests: XCTestCase {
    
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
        var sut: LaterGramImageLoader? = LaterGramImageLoader(url: url(), client: client)
        
        var capturedResults = [LaterGramImageLoader.Result]()
        sut?.load { capturedResults.append($0)}
        
        sut = nil
        client.completes(withStatusCode: 200, data: makeItemsJSON([]))
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL) -> (sut: LaterGramImageLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = LaterGramImageLoader(url: url, client: client)
        
        return (sut, client)
    }
    
    
    private func expect(_ sut: LaterGramImageLoader, toCompleteWith expectedResult: LaterGramImageLoader.Result,
                        when action: () -> Void, file: StaticString = #filePath,
                        line: UInt = #line) {
        let exp = expectation(description: "wait for load completion")
        sut.load { receivedResult in
            switch(receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as LaterGramImageLoader.Error), .failure(expectedError as LaterGramImageLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), received \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        private var messages = [
            (url: URL, completion: (HTTPClientResult) -> Void)
        ]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func completes(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func completes(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: messages[index].url, statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
        
    }
    
    private func url(_ string: String = "https://dummy-url.com") -> URL {
        URL(string: string)!
    }
    
    private func failure(_ error: LaterGramImageLoader.Error) -> LaterGramImageLoader.Result {
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
