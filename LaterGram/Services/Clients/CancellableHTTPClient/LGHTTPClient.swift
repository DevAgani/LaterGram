//
//  LGHTTPClient.swift
//  LaterGram
//
//  Created by George Nyakundi on 09/11/2022.
//

import Foundation

public protocol LGHTTPClientTask {
    func cancel()
}

public protocol LGHTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping(Result) -> Void) -> LGHTTPClientTask
}

public final class RemoteLaterGramImageDataLoader: LaterGramImageDataLoader {
    private let client: LGHTTPClient
    
    public init(client: LGHTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private final class LGHTTPClientTaskWrapper: LaterGramImageDataLoaderTask {
        private var completion: ((LaterGramImageDataLoader.Result) -> Void)?
        
        var wrapped: LGHTTPClientTask?
        
        init(_ completion: (@escaping (LaterGramImageDataLoader.Result) -> Void)) {
            self.completion = completion
        }
        
        func compete(with result: LaterGramImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (LaterGramImageDataLoader.Result) -> Void) -> LaterGramImageDataLoaderTask {
        let task = LGHTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: url, completion: { [weak self] result in
            guard self != nil else { return }
            task.compete(with: result
                .mapError { _ in Error.connectivity }
                .flatMap {(data, response) in
                    let isValid = response.statusCode == 200 && !data.isEmpty
                    return isValid ? .success(data) : .failure(Error.invalidData)
                }
            )
        })
        
        return task
    }
    
    
}
