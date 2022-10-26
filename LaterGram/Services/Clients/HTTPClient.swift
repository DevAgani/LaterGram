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

public protocol HTTPImageClientTask {
    func cancel()
}

public protocol HTTPImageClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse),Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPImageClientTask
}
