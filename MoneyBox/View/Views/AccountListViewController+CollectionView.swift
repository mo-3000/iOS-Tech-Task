// AccountListViewController+CollectionView.swift
// MoneyManager
//
// Created by Mohammed Ali on 24/10/2024.
//

import UIKit
import SwiftUI

extension AccountListViewController: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedAccount = collectionManager.dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        showAccountDetails(for: selectedAccount)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        cell.alpha = 0.0
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0.05 * Double(indexPath.row),
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: .curveEaseInOut,
            animations: {
                cell.transform = CGAffineTransform.identity
                cell.alpha = 1.0
            }, completion: nil
        )
    }
    
    // MARK: - Navigation
    
    private func showAccountDetails(for account: ProductViewData) {
        navigationItem.title = ""
        
        let backButtonAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationController.self])
        backButtonAppearance.tintColor = .white
        
        let detailViewModel = AccountDetailViewModel(account: account)
        let detailView = AccountDetailView(viewModel: detailViewModel)
        let hostingController = UIHostingController(rootView: detailView)
        
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
