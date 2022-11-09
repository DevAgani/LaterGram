//
//  LaterGramEndpoints.swift
//  LaterGram
//
//  Created by George Nyakundi on 21/10/2022.
//

import Foundation


public enum LaterGramEndpoint {
    case user
    case userDetails(Int)
    case media(Int)
    case mediaChildren(Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .user:
            return baseURL.appending(path: "/me")
        case let .userDetails(userID):
            let userfields = [
                "account_type",
                "username",
                "media_count"
            ].joined(separator: ",")

            return baseURL.appending(path: "/\(userID)").addQueryItems(ofKey: "fields", userfields)
        case let .media(userID):
            let mediaFields = [
                "id",
                "media_type",
                "media_url",
                "username",
                "timestamp"
            ].joined(separator: ",")
            
            return baseURL.appending(path: "/\(userID)/media").addQueryItems(ofKey: "fields", mediaFields)
        case let .mediaChildren(mediaID):
            return baseURL.appending(path: "/\(mediaID)/children")
        }
    }
}
