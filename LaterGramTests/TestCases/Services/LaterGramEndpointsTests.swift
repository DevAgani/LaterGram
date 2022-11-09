//
//  LaterGramEndpointsTests.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 21/10/2022.
//

import XCTest
import LaterGram

final class LaterGramEndpointsTests: XCTestCase {
    func test_user_endpointURL() {
        let userURL = URL(string: "\(anyBaseURLString())/me")!
        
        expect(userURL, whenEndpointIs: .user, withBaseURL: anyBaseURL())
    }
    
    func test_userDetails_endpointURL() {
        let userID = 289289
        let userDetailsURL = URL(string: "\(anyBaseURLString())/\(userID)?fields=account_type,username,media_count")!
        
        expect(userDetailsURL, whenEndpointIs: .userDetails(userID), withBaseURL: anyBaseURL())
    }
    
    func test_media_endpointURL() {
        let userID = 20092
        let mediaURL = URL(string: "\(anyBaseURLString())/\(userID)/media?fields=id,media_type,media_url,username,timestamp")!
        
        expect(mediaURL, whenEndpointIs: .media(userID), withBaseURL: anyBaseURL())
    }
    
    func test_mediaChildren_endpointURL() {
        let mediaID = 34343
        
        let mediaChildrenURL = URL(string: "\(anyBaseURLString())/\(mediaID)/children")!
        
        expect(mediaChildrenURL, whenEndpointIs: .mediaChildren(mediaID), withBaseURL: anyBaseURL())
    }
    
    
    
    // MARK: - Helpers
    
    private func expect(_ expectedURL: URL, whenEndpointIs endpoint: LaterGramEndpoint, withBaseURL baseURL: URL, file: StaticString = #filePath, line: UInt = #line) {
        
        let receievedURL = endpoint.url(baseURL: baseURL)
        XCTAssertEqual(expectedURL, receievedURL, file: file, line: line)
    }
    
    private func anyBaseURLString() -> String {
        "http://any-base-url.com"
    }
    private func anyBaseURL() -> URL {
        URL(string: anyBaseURLString())!
    }
}
