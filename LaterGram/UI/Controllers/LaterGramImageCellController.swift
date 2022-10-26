//
//  LaterGramImageCellController.swift
//  LaterGram
//
//  Created by George Nyakundi on 24/10/2022.
//


import UIKit

final class LaterGramImageCellController {
    private let viewModel: LaterGramImageViewModel<UIImage>
    private var cell: LaterGramImageCell?

    init(viewModel: LaterGramImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }

    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = binded(tableView.dequeueReusableCell())
        viewModel.loadImageData()
        return cell
    }

    func preload() {
        viewModel.loadImageData()
    }

    func cancelLoad() {
        releaseCellForReuse()
        viewModel.cancelImageDataLoad()
    }

    private func binded(_ cell: LaterGramImageCell) -> LaterGramImageCell {
        self.cell = cell

        cell.timestampLabel.text = viewModel.timestamp
        cell.onRetry = viewModel.loadImageData

        viewModel.onImageLoad = { [weak self] image in
            self?.cell?.gramImageView.setImageAnimated(image)
        }

        viewModel.onImageLoadingStateChange = { [weak self] isLoading in
            self?.cell?.imageContainer.isShimmering = isLoading
        }

        viewModel.onShouldRetryImageLoadStateChange = { [weak self] shouldRetry in
            self?.cell?.imageRetryButton.isHidden = !shouldRetry
        }

        return cell
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}

