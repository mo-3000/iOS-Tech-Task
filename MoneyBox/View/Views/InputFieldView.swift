//
//  InputFieldView.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit

public protocol InputFieldDelegate: AnyObject {
    func loginTextFieldDidBeginEditing(_ textField: UITextField)
}

final class InputFieldView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: InputFieldDelegate?
    
    var currentText: String {
        return inputTextField.text ?? ""
    }
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mutedBlue
        label.font = .systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.layer.borderColor = UIColor.lightBorder.cgColor
        textField.layer.borderWidth = 1
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isAccessibilityElement = true
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 11)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, inputTextField])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = false
        stackView.accessibilityElements = [descriptionLabel, inputTextField]
        return stackView
    }()
    
    // MARK: - Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialiseView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func initialiseView() {
        addSubview(containerStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            inputTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Configuration Methods
    
    func configureField(with title: String, secureEntry: Bool = false, fieldTag: Int) {
        descriptionLabel.text = title
        inputTextField.isSecureTextEntry = secureEntry
        inputTextField.returnKeyType = secureEntry ? .done : .next
        inputTextField.tag = fieldTag
        
        if secureEntry {
            addTogglePasswordVisibilityButton()
        }
        configureAccessibility(withTitle: title, secureEntry: secureEntry)
    }
    
    private func configureAccessibility(withTitle title: String, secureEntry: Bool) {
        containerStackView.accessibilityElements = [descriptionLabel, inputTextField, errorLabel]
        inputTextField.accessibilityLabel = secureEntry ? "Password Input" : "Text Input"
        descriptionLabel.accessibilityLabel = title
    }
    
    // MARK: - Error Handling Methods
    
    func displayError(message: String) {
        inputTextField.layer.borderColor = UIColor.red.cgColor
        descriptionLabel.textColor = .red
        errorLabel.text = message
        errorLabel.accessibilityLabel = message
        
        if !containerStackView.arrangedSubviews.contains(errorLabel) {
            containerStackView.addArrangedSubview(errorLabel)
        }
    }
    
    func clearError() {
        inputTextField.layer.borderColor = UIColor.lightBorder.cgColor
        descriptionLabel.textColor = .mutedBlue
        errorLabel.text = ""
        errorLabel.accessibilityLabel = ""
        
        if containerStackView.arrangedSubviews.contains(errorLabel) {
            containerStackView.removeArrangedSubview(errorLabel)
            errorLabel.removeFromSuperview()
        }
    }
    
    // MARK: - Utility Methods
    
    private func addTogglePasswordVisibilityButton() {
        let visibilityButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        visibilityButton.setImage(UIImage(systemName: "eye.fill")?.withTintColor(.accent ?? .black), for: .normal)
        visibilityButton.setImage(UIImage(systemName: "eye.slash.fill")?.withTintColor(.accent ?? .black), for: .selected)
        visibilityButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        inputTextField.rightView = visibilityButton
        inputTextField.rightViewMode = .always
        visibilityButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        inputTextField.isSecureTextEntry.toggle()
    }
}

// MARK: - UITextFieldDelegate

extension InputFieldView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.loginTextFieldDidBeginEditing(textField)
        return true
    }
}
