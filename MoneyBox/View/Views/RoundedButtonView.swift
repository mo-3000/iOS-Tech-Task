//
//  RoundedButtonView.swift
//  MoneyManager
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit

class RoundedButtonView: UIView {
    
    // MARK: - UI Components
    
    private lazy var circularButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.backgroundColor = .accent
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.isAccessibilityElement = true
        button.accessibilityTraits = .button
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .mutedBlue
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [circularButton, descriptionLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isAccessibilityElement = false
        return stack
    }()
    
    // MARK: - Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialiseView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialiseView()
    }
    
    // MARK: - Configuration
    
    func setupContent(amountText: String?, description: String?) {
        let displayAmount = amountText ?? "0"
        circularButton.setTitle("£\(displayAmount)", for: .normal)
        circularButton.accessibilityLabel = description
        descriptionLabel.text = description
        descriptionLabel.accessibilityLabel = description
    }
    
    // MARK: - Private Methods
    
    private func initialiseView() {
        addSubview(verticalStack)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: topAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            circularButton.heightAnchor.constraint(equalToConstant: 44),
            circularButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
}
