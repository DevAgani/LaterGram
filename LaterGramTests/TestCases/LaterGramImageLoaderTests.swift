//
//  LaterGramImageLoaderTests.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 20/10/2022.
//

import XCTest

class LaterGramImageLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}
protocol HTTPClient {
    func get(from url: URL)
}

final class LaterGramImageLoaderTests: XCTestCase {

    func test_init_doesNotRequestData(){
        let (_, client) = makeSUT(url: url())
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromAGivenURL() {
        let givenURL = url("https://very-secure-url.com")
        
        let (sut, client) = makeSUT(url: givenURL)
        
        sut.load()
        XCTAssertEqual(client.requestedURLs, [givenURL])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = url()
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
        
    }
  
    // MARK: - Helpers
    
    private func makeSUT(url: URL) -> (sut: LaterGramImageLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = LaterGramImageLoader(url: url, client: client)
        
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        var requestedURLs = [URL]()
       
        func get(from url: URL) {
            requestedURLs.append(url)
        }
    }
    
    private func url(_ string: String = "https://dummy-url.com") -> URL {
        URL(string: string)!
    }
}
