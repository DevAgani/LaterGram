//
//  LaterGramImageCell.swift
//  LaterGram
//
//  Created by George Nyakundi on 24/10/2022.
//

import UIKit

public final class LaterGramImageCell: UITableViewCell {
    @IBOutlet private(set) public var imageContainer: UIView!
    @IBOutlet private(set) public var gramImageView: UIImageView!
    @IBOutlet private(set) public var imageRetryButton: UIButton!
    @IBOutlet private(set) public var timestampLabel: UILabel!

    var onRetry: (() -> Void)?

    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
}
