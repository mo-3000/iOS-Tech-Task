//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit
import Networking

public protocol LoginViewModelDelegate: AnyObject {
    func loginTextFieldDidBeginEditing(_ textField: UITextField)
}

public protocol LoginViewModelProtocol: InputFieldDelegate {
    var provider: DataProviderLogic { get }
    var manager: SessionManagerProtocol { get }
    var delegate: LoginViewModelDelegate? { get set }
    func login(email: String, password: String)
    var onSuccess: ((LoginResponse.User) -> Void)? { get set }
    var onError: ((ErrorResponse) -> Void)? { get set }
}

final class LoginViewModel: LoginViewModelProtocol {
    
    weak var delegate: LoginViewModelDelegate?
    var provider: DataProviderLogic
    var manager: SessionManagerProtocol
    
    var onSuccess: ((LoginResponse.User) -> Void)?
    var onError: ((ErrorResponse) -> Void)?
    
    init(provider: DataProviderLogic = DataProvider(), manager: SessionManagerProtocol = SessionManager()) {
        self.provider = provider
        self.manager = manager
    }
    
    func login(email: String, password: String) {
        let request = LoginRequest(email: email, password: password)
        
        provider.login(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.manager.setUserToken(response.session.bearerToken)
                self?.onSuccess?(response.user)
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    func loginTextFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.loginTextFieldDidBeginEditing(textField)
    }
}
