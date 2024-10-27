//
//  AccountListViewController.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit
import Networking

final class AccountListViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: AccountListViewModelProtocol
    var collectionManager: AccountsCollectionHelperProtocol
    
    // MARK: - UI Components
    lazy var portfolioHeader: AccountScreenHeaderView = {
        let header = AccountScreenHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    lazy var investmentCollection: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionManager.layout
        )
        configureCollectionView(collection)
        return collection
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Lifecycle
    init(
        viewModel: AccountListViewModelProtocol,
        collectionManager: AccountsCollectionHelperProtocol
    ) {
        self.viewModel = viewModel
        self.collectionManager = collectionManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        bindViewModelEvents()
        viewModel.fetchProducts()
    }
    
    // MARK: - Private Methods
    private func setupInitialState() {
        view.backgroundColor = .white
        collectionManager.configureDataSource(for: investmentCollection)
        investmentCollection.refreshControl = refreshControl
    }
    
    private func bindViewModelEvents() {
        viewModel.loadingStatusDidUpdate = { [weak self] status in
            DispatchQueue.main.async {
                self?.handleStatusUpdate(status)
            }
        }
    }
    
    private func handleStatusUpdate(_ status: LoadingStatus) {
        switch status {
        case .inProgress:
            self.showLoadingIndicator(over: view)
        case .completed:
            self.refreshDisplay()
        case .error(let message):
            self.displayError(message: message)
        }
    }
    
    private func refreshDisplay() {
        hideLoadingIndicator()
        refreshControl.endRefreshing()
        guard let headerData = viewModel.portfolioData.headerData else { return }
        portfolioHeader.updateContent(with: headerData)
        
        collectionManager.applySnapshot(with: viewModel.portfolioData.productDetails ?? [])
        setupViewConstraints()
    }
    
    private func displayError(message: String?) {
        hideLoadingIndicator()
        refreshControl.endRefreshing()
        let alert = UIAlertController(
            title: "Oops!",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func configureCollectionView(_ collection: UICollectionView) {
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.identifier)
        collection.register(
            AccountHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AccountHeaderView.identifier
        )
        applyStyling(to: collection)
        collection.delegate = self
    }
    
    private func applyStyling(to collection: UICollectionView) {
        collection.isScrollEnabled = true
        collection.layer.shadowColor = UIColor.gray.cgColor
        collection.layer.shadowOpacity = 0.25
        collection.layer.shadowOffset = .zero
        collection.layer.shadowRadius = 4
        collection.layer.cornerRadius = 10
        collection.layer.masksToBounds = true
        collection.backgroundColor = .white
        collection.isAccessibilityElement = false
        collection.shouldGroupAccessibilityChildren = true
    }
    
    private func setupViewConstraints() {
        view.addSubview(portfolioHeader)
        view.addSubview(investmentCollection)
        
        NSLayoutConstraint.activate([
            portfolioHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            portfolioHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            portfolioHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            investmentCollection.topAnchor.constraint(equalTo: portfolioHeader.bottomAnchor),
            investmentCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            investmentCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            investmentCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func refreshData() {
        viewModel.fetchProducts()
    }
}
