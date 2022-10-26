//
//  AuthenticatedHTTPClientDecoraterTests.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 21/10/2022.
//

import XCTest
import LaterGram

final class AuthenticatedHTTPClientDecoraterTests: XCTestCase {
    func test_get_withSuccessfulToken_signsRequestWithToken(){
        let client = HTTPClientSpy()
        let unsignedRequest = url()
        
        let signedRequest = url().signed(with: anyToken())
        let tokenService = TokenServiceStub(stubbedToken: anyToken())
        
        let sut = AuthenticatedHTTPClientDecorater(decoratee: client, tokenService: tokenService)
        
        sut.get(from: unsignedRequest) { _ in }
        XCTAssertEqual(client.requestedURLs, [signedRequest])
    }
    
    func test_get_withSuccessfulTokenRequest_completesWithDecorateeResult() throws {
        let values = (Data("some data".utf8), httpURLResponse(200))
        let client = HTTPClientSpy()
        let tokenService = TokenServiceStub(stubbedToken: anyToken())
        let sut = AuthenticatedHTTPClientDecorater(decoratee: client, tokenService: tokenService)
        
        var receivedResult: HTTPClient.Result?
        sut.get(from: url()){ receivedResult = $0 }
        client.complete(with: values)
        
        let receivedValues = try XCTUnwrap(receivedResult)
        switch receivedValues {
        case let .success((data, response)):
            XCTAssertEqual(data, values.0)
            XCTAssertEqual(response, values.1)
        default:
            XCTFail("Expected \(values.0) and \(values.1), but received \(receivedValues)")
        }
    }
    
    func test_get_withfailedTokenRequest_fails(){
        let client = HTTPClientSpy()
        let tokenService = TokenServiceStub(stubbedError: anyNSError())
        
        let sut = AuthenticatedHTTPClientDecorater(decoratee: client, tokenService: tokenService)
        
        var receivedResult: HTTPClient.Result?
        
        sut.get(from: url()) { receivedResult = $0}
        
        XCTAssertEqual(client.requestedURLs, [])
        XCTAssertThrowsError(try receivedResult?.get())
    }
    
    func test_get_multipleTimes_reusesRunningTokenRequest() {
        let client = HTTPClientSpy()
        let service = TokenServiceSpy()
        
        let sut = AuthenticatedHTTPClientDecorater(decoratee: client, tokenService: service)
        
        sut.get(from: url()) { _ in }
        sut.get(from: url()) { _ in }
        
        XCTAssertEqual(service.tokenCount, 1)
        
        service.complete(with: anyNSError())
        
        sut.get(from: url()) { _ in }
        XCTAssertEqual(service.tokenCount, 2)
    }
    
    func test_get_multipletimes_completesWithRespectiveClientDecorateeResults() throws {
        let client = HTTPClientSpy()
        let tokenService = TokenServiceSpy()
        
        let sut = AuthenticatedHTTPClientDecorater(decoratee: client, tokenService: tokenService)
        
        // First request: index 0
        var result1: HTTPClient.Result?
        sut.get(from: url()) { result1 = $0}
        
        // Second request: index 1
        var result2: HTTPClient.Result?
        sut.get(from: url()) { result2 = $0}
        
        tokenService.completeSuccessfully(with: anyToken())
        
        // Complete first request: index 0
        let values = (Data("awesome data".utf8), httpURLResponse(200))
        client.complete(with: values, at: 0)
        
        let receivedValues1 = try XCTUnwrap(result1)
        switch receivedValues1 {
        case let .success((data, response)):
            XCTAssertEqual(data, values.0)
            XCTAssertEqual(response, values.1)
        default:
            XCTFail("Expected \(values.0) and \(values.1), but received \(receivedValues1)")
        }
        
        // Complete second request: index 1
        client.completes(with: anyNSError(), at: 1)
        XCTAssertThrowsError(try result2?.get())
        
    }
    
    // MARK: - Helpers
    
    private func anyToken() -> String {
        "someSEcur3Tok3nTh@tsLong3EnoughAndHardT0Cr4ck"
    }
    
    private func httpURLResponse(_ code: Int) -> HTTPURLResponse{
        HTTPURLResponse(url: url(), statusCode: code, httpVersion: nil, headerFields: nil)!
    }
    
    private final class TokenServiceStub: TokenService {
        private let result: TokenService.Result
        
        init(stubbedToken token: String) {
            self.result = .success(token)
        }
        
        init(stubbedError: Error) {
            self.result = .failure(stubbedError)
        }
        
        func getToken(completion: @escaping GetTokenCompletion) {
            completion(result)
        }
    }
    
    private final class TokenServiceSpy: TokenService {
        var tokenCompletions = [(TokenService.Result) -> Void]()
        
        var tokenCount: Int {
            tokenCompletions.count
        }
        
        func getToken(completion: @escaping GetTokenCompletion) {
            tokenCompletions.append(completion)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            tokenCompletions[index](.failure(error))
        }
        
        func completeSuccessfully(with token: String, at index: Int = 0) {
            tokenCompletions[index](.success(token))
        }
    }
}
