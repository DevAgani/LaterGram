//
//  UIViewController+Preview.swift
//  LaterGram
//
//  Created by George Nyakundi on 21/10/2022.
//

import SwiftUI

extension UIViewController {
    
    /// A view that represents a UIKit view controller.
    private struct Preview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
    
    /// Helper method to create a preview
    /// - Returns: A type that represents part of your app’s user interface and provides modifiers that you use to configure views.
    func toPreView() -> some View {
        // inject self (the current view controller) to the preview
        Preview(viewController: self)
    }
}
