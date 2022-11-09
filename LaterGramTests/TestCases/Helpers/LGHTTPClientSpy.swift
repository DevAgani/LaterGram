//
//  LGHTTPClientSpy.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 09/11/2022.
//

import Foundation
import LaterGram

class LGHTTPClientSpy: LGHTTPClient {
    
    private struct Task: LGHTTPClientTask {
        let callback: () -> Void
        func cancel() {
            callback()
        }
    }
    
    private var messages = [(url: URL, completion: (LGHTTPClient.Result) -> Void)]()
    private(set) var cancelledURLs = [URL]()
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    func get(from url: URL, completion: @escaping (LGHTTPClient.Result) -> Void) -> LaterGram.LGHTTPClientTask {
        messages.append((url, completion))
        
        return Task {[weak self] in
            self?.cancelledURLs.append(url)
        }
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
        
        messages[index].completion(.success((data, response)))
    }
}
