//
//  AuthenticatedHTTPClientDecoraterTests.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 21/10/2022.
//

import XCTest
import LaterGram

class AuthenticatedHTTPClientDecorater: HTTPClient {
    func get(from url: URL, completion: @escaping (LaterGram.HTTPClientResult) -> Void) {

    }
}

final class AuthenticatedHTTPClientDecoraterTests: XCTestCase {
    func test_get_withToken_signsRequestWithToken(){
        
    }
}
