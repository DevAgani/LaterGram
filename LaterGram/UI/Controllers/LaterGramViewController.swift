//
//  LaterGramViewController.swift
//  LaterGram
//
//  Created by George Nyakundi on 24/10/2022.
//

import UIKit

public final class LaterGramViewController: UITableViewController, UITableViewDataSourcePrefetching {
    @IBOutlet private(set) public var errorView: ErrorView!
    var viewModel: LaterGramViewModel? {
        didSet { bind() }
    }

    var tableModel = [LaterGramImageCellController]() {
        didSet { tableView.reloadData() }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        formatNavigationController()
        refresh()
    }

    @IBAction private func refresh() {
        viewModel?.load()
    }

    func bind() {
        title = viewModel?.title
        viewModel?.onLoadingStateChange = { [weak self] isLoading in
            if isLoading {
                self?.refreshControl?.beginRefreshing()
            } else {
                self?.refreshControl?.endRefreshing()
            }
        }

        viewModel?.onLoadError = { [weak self] message in
            if let message = message {
                self?.errorView.show(message: message)
            } else {
                self?.errorView.hideMessage()
            }
        }
    }
    
    private func formatNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.sizeTableHeaderToFit()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }

    private func cellController(forRowAt indexPath: IndexPath) -> LaterGramImageCellController {
        return tableModel[indexPath.row]
    }

    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}
