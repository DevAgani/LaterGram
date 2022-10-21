//
//  RootViewController.swift
//  LaterGram
//
//  Created by George on 20/10/2022.
//

import UIKit

final class RootViewController: UIViewController {
    
    //MARK:- View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        view.backgroundColor = .systemBackground
        title = "LaterGram"
    }
    
    
    // MARK:- Helper Methods
    func setup() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
    }
}

#if DEBUG
import SwiftUI
struct RootViewControllerPreview: PreviewProvider {
    static var previews: some View {
       return UINavigationController(rootViewController: RootViewController()).toPreView()
    }
}
#endif
