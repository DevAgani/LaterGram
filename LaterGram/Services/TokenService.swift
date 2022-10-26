//
//  TokenService.swift
//  LaterGram
//
//  Created by George Nyakundi on 21/10/2022.
//

import Foundation

/// Protocol for any token provider
public protocol TokenService {
    typealias Result = Swift.Result<String, Error>
    typealias GetTokenCompletion = (Result) -> Void
    
    /// Returns a Swift result of `Result<String, Error>`
    /// - Parameter completion: <#completion description#>
    func getToken(completion: @escaping GetTokenCompletion)
}

