//
//  ImageItem.swift
//  LaterGram
//
//  Created by George Nyakundi on 21/10/2022.
//

import Foundation

public struct ImageItem: Equatable {
    let id: String
    let type: String
    let url: URL
    let username: String
    let timestamp: Date
    
    public init(id: String, type: String, url: URL, username: String, timestamp: Date) {
        self.id = id
        self.type = type
        self.url = url
        self.username = username
        self.timestamp = timestamp
    }
}
