//
//  LaterGramUIComposer.swift
//  LaterGram
//
//  Created by George Nyakundi on 24/10/2022.
//

import UIKit

public final class LaterGramUIComposer {
    private init() {}

    
    public static func composedWith(loader: LaterGramLoader, imageLoader: LaterGramImageDataLoader) -> LaterGramViewController {
        let laterGramViewModel = LaterGramViewModel(laterGramLoader: MainQueueDispatchDecorator(decoratee: loader))
        
        let viewController = LaterGramViewController.makeWith(
            viewModel: laterGramViewModel)
        
        laterGramViewModel.onLoad = adaptImageItemsToCellControllers(
            forwardingTo: viewController,
            imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader))
        
        return viewController
    }
 
    private static func adaptImageItemsToCellControllers(forwardingTo controller: LaterGramViewController, imageLoader: LaterGramImageDataLoader) -> ([ImageItem]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                LaterGramImageCellController(viewModel:
                                            LaterGramImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
            }
        }
    }
}

private extension LaterGramViewController {
    static func makeWith(viewModel: LaterGramViewModel) -> LaterGramViewController {
        let bundle = Bundle(for: LaterGramViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! LaterGramViewController
        feedController.viewModel = viewModel
        return feedController
    }
}


