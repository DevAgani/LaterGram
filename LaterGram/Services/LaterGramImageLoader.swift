//
//  LaterGramImageLoader.swift
//  LaterGram
//
//  Created by George Nyakundi on 25/10/2022.
//

import Foundation

public protocol LaterGramImageDataLoaderTask {
    func cancel()
}

public protocol LaterGramImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> LaterGramImageDataLoaderTask
}


