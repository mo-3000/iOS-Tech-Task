//
//  DataProvider.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 20.07.2022.
//

import Combine

@available(iOS 13.0, *)
public protocol DataProviderLogic: AnyObject {
    func login(request: LoginRequest, completion: @escaping ((Result<LoginResponse, ErrorResponse>) -> Void))
    func fetchAccounts(completion: @escaping ((Result<AccountResponse, ErrorResponse>) -> Void))
    func addMoney(request: OneOffPaymentRequest) -> AnyPublisher<OneOffPaymentResponse, ErrorResponse>
}

@available(iOS 13.0, *)
public class DataProvider: DataProviderLogic {

    public init() {}

    public func fetchAccounts(completion: @escaping ((Result<AccountResponse, ErrorResponse>) -> Void)) {
        API.Account.products.fetchResponse(completion: completion)
    }

    public func login(request: LoginRequest, completion: @escaping ((Result<LoginResponse, ErrorResponse>) -> Void)) {
        API.Login.login(request: request).fetchResponse(completion: completion)
    }

    public func addMoney(request: OneOffPaymentRequest) -> AnyPublisher<OneOffPaymentResponse, ErrorResponse> {
        return API.Account.addMoney(request: request).fetchResponsePublisher()
    }
}

