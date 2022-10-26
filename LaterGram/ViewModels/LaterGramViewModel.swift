//
//  LaterGramViewModel.swift
//  LaterGram
//
//  Created by George Nyakundi on 24/10/2022.
//

import Foundation

final class LaterGramViewModel {
    typealias Observer<T> = (T) -> Void

    private let laterGramLoader: LaterGramLoader

    init(laterGramLoader: LaterGramLoader) {
        self.laterGramLoader = laterGramLoader
    }

    var title: String {
        "LaterGram"
    }

    var onLoadingStateChange: Observer<Bool>?
    var onLoad: Observer<[ImageItem]>?
    var onLoadError: Observer<String?>?

    func load() {
        onLoadingStateChange?(true)
        onLoadError?(.none)
        laterGramLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.onLoad?(feed)
            case .failure:
                self?.onLoadError?("Something went wrong")
            }

            self?.onLoadingStateChange?(false)
        }
    }
}

