//
//  E2ETests.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 24/10/2022.
//

import XCTest
import LaterGram

final class E2ETests: XCTestCase {
    func test_endpoint() throws{
        let url = URL(string: "https://gist.githubusercontent.com/DevAgani/040ce4e21c702eb46f2ef887b84eaf16/raw/3a2d615649d071de33e9d708b5fdd5b4bc683b24/testData.json")!
        
        let client = URLSessionHTTPClient()
        let loader = RemoteLaterGramLoader(url: url, client: client)
        
        let exp = expectation(description: "Wait for load expection")
        var receivedResult: LaterGramLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        let receivedfeedResult = try XCTUnwrap(receivedResult)
        
        switch receivedfeedResult {
        case let .success(feed):
            XCTAssertEqual(feed.count, 5)
        default:
            XCTFail("Unable to fetch images")
        }
     
    }
}
