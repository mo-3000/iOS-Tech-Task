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
    var dataProvider: DataProviderLogic { get }
    var sessionManager: SessionManagerProtocol { get }
    var delegate: LoginViewModelDelegate? { get set }
    func login(email: String, password: String)
    var onSuccess: ((LoginResponse.User) -> Void)? { get set }
    var onError: ((ErrorResponse) -> Void)? { get set }
}

final class LoginViewModel: LoginViewModelProtocol {
    
    weak var delegate: LoginViewModelDelegate?
    var dataProvider: DataProviderLogic
    var sessionManager: SessionManagerProtocol
    
    var onSuccess: ((LoginResponse.User) -> Void)?
    var onError: ((ErrorResponse) -> Void)?
    
    init(provider: DataProviderLogic = DataProvider(), manager: SessionManagerProtocol = SessionManager()) {
        self.dataProvider = provider
        self.sessionManager = manager
    }
    
    func login(email: String, password: String) {
        let request = LoginRequest(email: email, password: password)
        
        dataProvider.login(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.sessionManager.setUserToken(response.session.bearerToken)
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
