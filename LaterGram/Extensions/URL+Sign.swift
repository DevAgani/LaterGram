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
        let url = self
        url.addQueryItems(ofKey: "access_token", token)
        return url
    }
    
    /// Adds query items to a url
    /// - Parameters:
    ///   - key: key
    ///   - item: values
    /// - Returns: `URL`
    @discardableResult
    public func addQueryItems(ofKey key: String, _ item: String) -> URL {
        var url = self
        let tokenQueryItem = URLQueryItem(name: key, value: item)
        url.append(queryItems: [tokenQueryItem])
        return url
    }
}
