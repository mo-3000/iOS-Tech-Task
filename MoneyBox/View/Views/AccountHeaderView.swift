//
//  AccountHeaderView.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit

class AccountHeaderView: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "AccountSectionHeader"
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .deepSea
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()
    
    // MARK: - Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderView()
        animateHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configureHeader(withTitle title: String) {
        headerTitleLabel.text = title
        headerTitleLabel.accessibilityLabel = title
        animateHeaderView()
    }
    
    // MARK: - Private Methods
    
    private func setupHeaderView() {
        addSubview(headerTitleLabel)
        layoutHeaderConstraints()
    }
    
    private func layoutHeaderConstraints() {
        NSLayoutConstraint.activate([
            headerTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func animateHeaderView() {
        headerTitleLabel.alpha = 0
        headerTitleLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.3,
            options: [.curveEaseInOut],
            animations: {
                self.headerTitleLabel.alpha = 1
                self.headerTitleLabel.transform = .identity
            },
            completion: nil
        )
    }
}
