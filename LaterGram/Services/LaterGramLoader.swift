//
//  LaterGramLoader.swift
//  LaterGram
//
//  Created by George Nyakundi on 21/10/2022.
//

import Foundation


/// Protocol to be used when implementing images loader
public protocol LaterGramLoader {
    typealias Result = Swift.Result<[ImageItem],Error>
    
    func load(completion: @escaping(Result) -> Void)
}

public class RemoteLaterGramLoader: LaterGramLoader {
    let url: URL
    let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping(LaterGramLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(GramItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
