//
//  URLSessionHTTPImageClient.swift
//  LaterGram
//
//  Created by George Nyakundi on 25/10/2022.
//

import Foundation

public class URLSessionHTTPImageClient: HTTPImageClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error { }
    
    private struct URLSessionTaskWrapper: HTTPImageClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func get(from url: URL, completion: @escaping (HTTPImageClient.Result) -> Void) -> HTTPImageClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
            } else if let data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }
        
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}

final class GramImageDataMapper {
    enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.statusCode == 200, !data.isEmpty else {
            throw Error.invalidData
        }
        return data
    }
}
