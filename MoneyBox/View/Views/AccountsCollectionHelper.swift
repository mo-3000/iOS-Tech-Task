//
//  ProductCollectionHelper.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit

typealias SectionID = Int

protocol AccountsCollectionHelperProtocol {
    func configureDataSource(for collectionView: UICollectionView)
    func applySnapshot(with items: [ProductViewData])
    var dataSource: UICollectionViewDiffableDataSource<SectionID, ProductViewData>? { get set }
    var layout: UICollectionViewCompositionalLayout { get }
}

class AccountsCollectionHelper: AccountsCollectionHelperProtocol {
    
    // MARK: - Properties
    var dataSource: UICollectionViewDiffableDataSource<SectionID, ProductViewData>?
    
    // MARK: - Compositional Layout
    var layout: UICollectionViewCompositionalLayout {
        createCompositionalLayout()
    }
    
    // MARK: - Data Source Setup
    func configureDataSource(for collectionView: UICollectionView) {
        configureCellRegistration(for: collectionView)
    }
    
    // MARK: - Snapshot Application
    func applySnapshot(with items: [ProductViewData]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionID, ProductViewData>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Private Helper Methods
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(60)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(60)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureCellRegistration(for collectionView: UICollectionView) {
        let cellRegistration = UICollectionView.CellRegistration<AccountCell, ProductViewData> { cell, _, product in
            cell.configure(with: product)
        }
        
        let supplementaryViewRegistration = UICollectionView.SupplementaryRegistration<AccountHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            supplementaryView.configureHeader(withTitle: "Your Accounts")
        }
        
        dataSource = UICollectionViewDiffableDataSource<SectionID, ProductViewData>(
            collectionView: collectionView
        ) { collectionView, indexPath, product in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryViewRegistration, for: indexPath)
        }
    }
    
}
