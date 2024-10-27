//
//  AccountScreenHeaderView.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit

final class AccountScreenHeaderView: UIView {
    
    // MARK: - UI Components
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .header
        return label
    }()
    
    private lazy var motivationalMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var balanceValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .deepSea
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var earningsValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .oceanBlue
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var earningsTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .deepSea
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    // MARK: - Stack Views
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, motivationalMessageLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var earningsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [earningsValueLabel, earningsTitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var balanceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [balanceValueLabel, balanceTitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileStackView, balanceStackView, earningsStackView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Configuration
    
    private func configureView() {
        addSubview(mainStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    
    // MARK: - Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateContent(with data: AccountSummaryData) {
        balanceTitleLabel.text = "Account Total Balance"
        earningsValueLabel.attributedText = data.netEarnings?.formatAsCurrencyAttributedString(primaryFontSize: 20, secondaryFontSize: 16)
        earningsTitleLabel.text = "Total Earnings"
        balanceValueLabel.attributedText = data.totalPlanAmount?.formatAsCurrencyAttributedString(primaryFontSize: 40, secondaryFontSize: 20)
        welcomeLabel.text = data.welcomeMessage
        motivationalMessageLabel.text = "Building your Moneybox, one step at a time."
        setupAccessibility(with: data)
        
        animateMainStackView()
    }
    
    private func animateMainStackView() {
        mainStackView.alpha = 0
        mainStackView.transform = CGAffineTransform(translationX: 0, y: 30)
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.3,
            options: [.curveEaseInOut],
            animations: {
                self.mainStackView.alpha = 1
                self.mainStackView.transform = .identity
            },
            completion: nil
        )
    }
    
    private func setupAccessibility(with data: AccountSummaryData) {
        balanceTitleLabel.accessibilityLabel = "Account Total Balance"
        earningsValueLabel.accessibilityLabel = "Net earnings: \(data.netEarnings ?? 0)"
        earningsTitleLabel.accessibilityLabel = "Total Earnings"
        balanceValueLabel.accessibilityLabel = "Total plan amount: \(data.totalPlanAmount ?? 0)"
        welcomeLabel.accessibilityLabel = data.welcomeMessage
        motivationalMessageLabel.accessibilityLabel = "Building your Moneybox, one step at a time."
    }
}
