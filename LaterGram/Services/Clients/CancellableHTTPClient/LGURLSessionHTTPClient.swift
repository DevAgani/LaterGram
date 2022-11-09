//
//  LGURLSessionHTTPClient.swift
//  LaterGram
//
//  Created by George Nyakundi on 09/11/2022.
//

import Foundation

public final class LGURLSessionHTTPClient: LGHTTPClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct LGURLSessionTaskWrapper: LGHTTPClientTask {
       
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
        
    }
    
    public func get(from url: URL, completion: @escaping (LGURLSessionHTTPClient.Result) -> Void) -> LGHTTPClientTask {
        
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error {
                    throw error
                } else if let data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        
        task.resume()
        return LGURLSessionTaskWrapper(wrapped: task)
    }
}
