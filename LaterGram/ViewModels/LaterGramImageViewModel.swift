//
//  LaterGramImageViewModel.swift
//  LaterGram
//
//  Created by George Nyakundi on 24/10/2022.
//

import Foundation

final class LaterGramImageViewModel<Image> {
    typealias Observer<T> = (T) -> Void

    private var task: LaterGramImageDataLoaderTask?
    private let model: ImageItem
    private let imageLoader: LaterGramImageDataLoader
    private let imageTransformer: (Data) -> Image?

    init(model: ImageItem, imageLoader: LaterGramImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }

    var timestamp: String? {
        return model.timestamp.formatted(date: .abbreviated, time: .standard)
    }

    var onImageLoad: Observer<Image>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?

    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }

    private func handle(_ result: LaterGramImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }

    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}

