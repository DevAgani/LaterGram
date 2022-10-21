//
//  HTTPClientSpy.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 21/10/2022.
//

import Foundation
import LaterGram

class HTTPClientSpy: HTTPClient {
    
    private var messages = [
        (url: URL, completion: (HTTPClient.Result) -> Void)
    ]()
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        messages.append((url, completion))
    }
    
    func completes(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func completes(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(url: messages[index].url, statusCode: code, httpVersion: nil, headerFields: nil)!
        messages[index].completion(.success((data, response)))
    }
    
    func complete(with values: (Data, HTTPURLResponse), at index: Int = 0 ) {
        messages[index].completion(.success(values))
    }
    
}
