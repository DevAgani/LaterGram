//
//  LaterGramImageLoaderTests.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 20/10/2022.
//

import XCTest

class LaterGramImageLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

final class LaterGramImageLoaderTests: XCTestCase {

    func test_init_doesNotRequestData(){
        let client = HTTPClient()
        _ = LaterGramImageLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
