//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//

import UIKit
import Networking

class LoginViewController: UIViewController {
    
    private lazy var appLogo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "moneybox")
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.isAccessibilityElement = true
        logo.accessibilityTraits = .image
        logo.accessibilityLabel = "MoneyBox Logo"
        return logo
    }()
    
    private lazy var emailField: InputFieldView = {
        let field = InputFieldView()
        field.configureField(with: "Email", secureEntry: false, fieldTag: 0)
        field.delegate = viewModel
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var passwordField: InputFieldView = {
        let field = InputFieldView()
        field.configureField(with: "Password", secureEntry: true, fieldTag: 1)
        field.delegate = viewModel
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var inputStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.addArrangedSubview(emailField)
        stack.addArrangedSubview(passwordField)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var submitButton: LoginButton = {
        let button = LoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private var viewModel: LoginViewModelProtocol
    
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        setupCallbacks()
        viewModel.delegate = self
    }
    
    @objc private func handleLogin() {
        clearErrorMessages()
        submitButton.showLoadingState()
        
        viewModel.login(email: emailField.currentText, password: passwordField.currentText)
    }
    
    private func setupCallbacks() {
        viewModel.onSuccess = { [weak self] user in
            self?.submitButton.hideLoadingState()
            self?.navigateToUserAccounts(user: user)
        }
        
        viewModel.onError = { [weak self] error in
            self?.submitButton.hideLoadingState()
            self?.displayError(error)
        }
    }
    
    private func displayError(_ error: ErrorResponse) {
        switch error.loginError {
        case .email:
            emailField.displayError(message: error.email)
        case .password:
            passwordField.displayError(message: error.password)
        case .unknown:
            showAlert(for: error)
        }
    }
    
    private func showAlert(for error: ErrorResponse) {
        let alert = UIAlertController(title: error.name, message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func navigateToUserAccounts(user: LoginResponse.User) {
        let accountViewController = AccountListViewController(
            viewModel: AccountListViewModel(user: user),
            collectionManager: AccountsCollectionHelper()
        )
        navigationController?.setViewControllers([accountViewController], animated: true)
    }
    
    private func configureLayout() {
        view.addSubview(appLogo)
        view.addSubview(inputStackView)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            appLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            appLogo.widthAnchor.constraint(equalToConstant: 200),
            appLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            inputStackView.topAnchor.constraint(equalTo: appLogo.bottomAnchor, constant: 40),
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            submitButton.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func loginTextFieldDidBeginEditing(_ textField: UITextField) {
        clearErrorMessages()
    }
    
    private func clearErrorMessages() {
        emailField.clearError()
        passwordField.clearError()
    }
}
