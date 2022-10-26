//
//  MainQueueDispatchDecorator.swift
//  LaterGram
//
//  Created by George Nyakundi on 24/10/2022.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T

    init(decoratee: T) {
        self.decoratee = decoratee
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }

        completion()
    }
}

extension MainQueueDispatchDecorator: LaterGramLoader where T == LaterGramLoader {
    func load(completion: @escaping (LaterGramLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}

extension MainQueueDispatchDecorator: LaterGramImageDataLoader where T == LaterGramImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (LaterGramImageDataLoader.Result) -> Void) -> LaterGramImageDataLoaderTask {
        return decoratee.loadImageData(from: url) {[weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
