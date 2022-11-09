//
//  SceneDelegate.swift
//  LaterGram
//
//  Created by George on 20/10/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let controller = makeRootViewController()
        window?.rootViewController = controller
        
        window?.makeKeyAndVisible()
    }
    
    private func makeRootViewController() -> UIViewController {
        let baseURL = URL(string: "https://graph.instagram.com/v15.0")!
        let client = URLSessionHTTPClient()
        let lgClient = LGURLSessionHTTPClient()
        let tokenService = LaterGramTokenService()
        let authenticatedClient = AuthenticatedHTTPClientDecorater(decoratee: client, tokenService: tokenService)
        
        // TODO: Fetch this from the Network
        let userID = 3979023678879161
        
        let url = LaterGramEndpoint.media(userID).url(baseURL: baseURL)
        
        let laterGramLoader = RemoteLaterGramLoader(url: url, client: authenticatedClient)
        
        let imageLoader = RemoteLaterGramImageDataLoader(client: lgClient)
        
        let view = UINavigationController(rootViewController: LaterGramUIComposer.composedWith(loader: laterGramLoader, imageLoader: imageLoader))
        return view
    }
}


