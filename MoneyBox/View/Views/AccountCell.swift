//
//  AccountCell.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit

class AccountCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "AccountCell"
    private let imageLoader = AsyncImageFetcher()
    
    private lazy var bubbleBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [logoContainer, titleStackView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    private lazy var logoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 48),
            logoImageView.heightAnchor.constraint(equalToConstant: 48),
            view.widthAnchor.constraint(equalToConstant: 48)
        ])
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, growthLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private lazy var growthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .oceanBlue
        return label
    }()
    
    private lazy var valuesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var valuesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [planValueStack, moneyBoxStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        return stack
    }()
    
    private lazy var planValueStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [planTitleLabel, amountLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var planTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        label.text = "Plan Value"
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .deepSea
        return label
    }()
    
    private lazy var moneyBoxStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [moneyBoxTitleLabel, moneyBoxLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var moneyBoxTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        label.text = "MoneyBox"
        return label
    }()
    
    private lazy var moneyBoxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .deepSea
        return label
    }()
    
    private lazy var disclosureButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        button.setImage(UIImage(systemName: "chevron.right", withConfiguration: configuration), for: .normal)
        button.tintColor = .oceanBlue
        button.accessibilityLabel = "More Information"
        button.accessibilityTraits = .button
        return button
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        return view
    }()
    
    // MARK: - Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupCellLayout() {
        contentView.addSubview(bubbleBackgroundView)
        
        bubbleBackgroundView.addSubview(headerStackView)
        bubbleBackgroundView.addSubview(separatorLine)
        bubbleBackgroundView.addSubview(valuesContainerView)
        
        valuesContainerView.addSubview(valuesStackView)
        valuesContainerView.addSubview(disclosureButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bubbleBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            headerStackView.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 16),
            headerStackView.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -16),
            
            separatorLine.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 16),
            separatorLine.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            valuesContainerView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            valuesContainerView.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor),
            valuesContainerView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor),
            valuesContainerView.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor),
            
            valuesStackView.topAnchor.constraint(equalTo: valuesContainerView.topAnchor, constant: 16),
            valuesStackView.leadingAnchor.constraint(equalTo: valuesContainerView.leadingAnchor, constant: 16),
            valuesStackView.bottomAnchor.constraint(equalTo: valuesContainerView.bottomAnchor, constant: -16),
            
            disclosureButton.centerYAnchor.constraint(equalTo: valuesContainerView.centerYAnchor),
            disclosureButton.trailingAnchor.constraint(equalTo: valuesContainerView.trailingAnchor, constant: -16),
            disclosureButton.widthAnchor.constraint(equalToConstant: 20),
            disclosureButton.heightAnchor.constraint(equalToConstant: 20),
            
            valuesStackView.trailingAnchor.constraint(equalTo: disclosureButton.leadingAnchor, constant: -16),
            
            bubbleBackgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 140)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with data: ProductViewData) {
        titleLabel.text = data.displayName
        growthLabel.text = "\(data.earningsPercentage ?? 0.0)%"
        amountLabel.attributedText = data.totalPlanValue?.formatAsCurrencyAttributedString(primaryFontSize: 20, secondaryFontSize: 16)
        moneyBoxLabel.attributedText = data.availableMoneyBox?.formatAsCurrencyAttributedString(primaryFontSize: 20, secondaryFontSize: 16)
        configureAccessibility(with: data)
        loadImage(from: data.productLogoURL)
    }
    
    private func loadImage(from url: String?) {
        Task {
            do {
                let image = try await imageLoader.fetchImage(from: url)
                logoImageView.image = image
            } catch {
                logoImageView.image = UIImage(systemName: "banknote.fill")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
        titleLabel.text = nil
        growthLabel.text = nil
        amountLabel.attributedText = nil
        moneyBoxLabel.attributedText = nil
    }
    
    // MARK: - Accessibility
    
    private func configureAccessibility(with data: ProductViewData) {
        isAccessibilityElement = true
        accessibilityLabel = "\(data.displayName ?? ""), Plan Value: \(data.totalPlanValue ?? 0), MoneyBox: \(data.availableMoneyBox ?? 0), earning \(data.earningsPercentage ?? 0.0)%"
        accessibilityHint = "Tap for more details"
        
        [logoImageView, titleLabel, growthLabel, amountLabel, moneyBoxLabel, planTitleLabel, moneyBoxTitleLabel].forEach {
            $0.isAccessibilityElement = false
        }
    }
}
