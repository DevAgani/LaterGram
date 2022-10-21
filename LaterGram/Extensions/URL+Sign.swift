//
//  URL+Sign.swift
//  LaterGram
//
//  Created by George Nyakundi on 21/10/2022.
//

import Foundation

extension URL {
    
    /// Appends a token to the url
    /// - Parameter token: valid token
    /// - Returns: URL
    public func signed(with token: String) -> URL {
        var url = self
        let tokenQueryItem = URLQueryItem(name: "access_token", value: token)
        url.append(queryItems: [tokenQueryItem])
        return url
    }
}
