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
        let controller = UINavigationController(rootViewController: RootViewController())
        window?.rootViewController = controller
        
        window?.makeKeyAndVisible()
    }

    
}

