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
        let client = URLSessionHTTPClient()
        
        let url = URL(string: "https://gist.githubusercontent.com/DevAgani/040ce4e21c702eb46f2ef887b84eaf16/raw/3a2d615649d071de33e9d708b5fdd5b4bc683b24/testData.json")!
        
        let laterGramLoader = RemoteLaterGramLoader(url: url, client: client)
        let view = UINavigationController(rootViewController: LaterGramUIComposer.composedWith(loader: laterGramLoader, imageLoader: AlwaysFailingLoader(delay: 1.3)))
        return view
    }
}


