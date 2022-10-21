//
//  HTTPClient.swift
//  LaterGram
//
//  Created by George Nyakundi on 21/10/2022.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse),Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
