//
//  LoginButton.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit

class LoginButton: UIButton {
    
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupLoadingIndicator()
        setupAccessibility()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Configuration
    
    private func setupLoadingIndicator() {
        loadingIndicator.color = .white
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        loadingIndicator.isHidden = true
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
        accessibilityLabel = "Login Button"
    }
    
    private func setupButton() {
        backgroundColor = .accent
        setTitle("Log in", for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    // MARK: - Public Methods
    
    func showLoadingState() {
        setTitle(nil, for: .normal)
        accessibilityLabel = "Loading"
        isEnabled = false
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingState() {
        setTitle("Log in", for: .normal)
        accessibilityLabel = "Login Button"
        isEnabled = true
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
}
