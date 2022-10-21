//
//  LaterGramTokenServiceTests.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 21/10/2022.
//

import XCTest
import LaterGram

final class LaterGramTokenServiceTests: XCTestCase {
    
    func test_getToken_fails_ifConfigFileDoesNotExist() throws {
        let bundle = Bundle(for: LaterGramTokenServiceTests.self)
        let tokenService = LaterGramTokenService(fromFile:"test", bundle: bundle)
        
        var receivedResult: TokenService.Result?
        tokenService.getToken { receivedResult = $0 }
        
        let receivedTokenResult = try XCTUnwrap(receivedResult)
        
        switch receivedTokenResult {
        case let .failure(error):
            XCTAssertEqual(error as? LaterGramTokenService.Error, LaterGramTokenService.Error.fileNotFound)
        default:
            XCTFail("Should fail if file does not exists")
        }
    }
    
    func test_getToken_succeeds_ifConfigFileExists() throws {
        let bundle = Bundle(for: LaterGramTokenServiceTests.self)
        let tokenService = LaterGramTokenService(bundle: bundle)
        
        var receivedResult: TokenService.Result?
        tokenService.getToken { receivedResult = $0 }
        
        let receivedTokenResult = try XCTUnwrap(receivedResult)
        
        switch receivedTokenResult {
        case let .success(token):
            XCTAssertEqual(token, "REPLACE_ME🥹")
        default:
            XCTFail("Should fail if file exists but unable to decode the values")
        }
    }
}
