//
//  UITableView+Dequeueing.swift
//  LaterGram
//
//  Created by George Nyakundi on 24/10/2022.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}

