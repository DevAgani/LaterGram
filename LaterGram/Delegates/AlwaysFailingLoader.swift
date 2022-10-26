//
//  AlwaysFailingLoader.swift
//  LaterGram
//
//  Created by George Nyakundi on 24/10/2022.
//

import Foundation

public final class AlwaysFailingLoader {
    private let delay: TimeInterval
    private let queue = DispatchQueue(label: "AlwaysFailingLoader.background-queue")

    public init(delay: TimeInterval) {
        self.delay = delay
    }
}

extension AlwaysFailingLoader: LaterGramImageDataLoader {
    private struct LoadError: Error {}
    private final class Task: LaterGramImageDataLoaderTask {
        func cancel() {}
    }
    
    public func loadImageData(from url: URL, completion: @escaping (LaterGramImageDataLoader.Result) -> Void) -> LaterGramImageDataLoaderTask {
        queue.asyncAfter(deadline: .now() + delay) {
            completion(.failure(LoadError()))
        }
        return Task()
    }
}

extension AlwaysFailingLoader: LaterGramLoader {
    
    public func load(completion: @escaping (LaterGramLoader.Result) -> Void) {
        queue.asyncAfter(deadline: .now() + delay) {
            completion(.failure(LoadError()))
        }
    }
}
