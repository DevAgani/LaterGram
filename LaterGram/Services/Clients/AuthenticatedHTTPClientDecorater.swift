//
//  AuthenticatedHTTPClientDecorater.swift
//  LaterGram
//
//  Created by George Nyakundi on 21/10/2022.
//

import Foundation

/// Specialized `HTTPClient` for perform requests that require authentication
public class AuthenticatedHTTPClientDecorater: HTTPClient {
    
    private let decoratee: HTTPClient
    private let tokenService: TokenService
    
    private var pendingTokenRequests = [TokenService.GetTokenCompletion]()
    
    public init(decoratee: HTTPClient, tokenService: TokenService) {
        self.decoratee = decoratee
        self.tokenService = tokenService
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        pendingTokenRequests.append { [decoratee] tokenResult in
            switch tokenResult {
            case let .success(token):
                decoratee.get(from: url.signed(with: token), completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
        
        guard pendingTokenRequests.count == 1 else { return }
        
        tokenService.getToken {[weak self] tokeResult in
            self?.pendingTokenRequests.forEach { $0(tokeResult) }
            self?.pendingTokenRequests = []
        }
    }
}
