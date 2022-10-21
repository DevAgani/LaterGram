//
//  LaterGramImageLoaderTests.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 20/10/2022.
//

import XCTest

class LaterGramImageLoader {
    private var client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() {
        client.get(from: URL(string: "http://dummy-url.com")!)
    }
}
protocol HTTPClient {
    func get(from url: URL)
}

final class LaterGramImageLoaderTests: XCTestCase {

    func test_init_doesNotRequestData(){
        let client = HTTPClientSpy()
        _ = LaterGramImageLoader(client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let client = HTTPClientSpy()
        let sut = LaterGramImageLoader(client: client)
        
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
    
    // MARK: - Helpers
    private class HTTPClientSpy: HTTPClient {
        
        var requestedURL: URL?
       
        func get(from url: URL) {
            self.requestedURL = url
        }
        
    }
}
