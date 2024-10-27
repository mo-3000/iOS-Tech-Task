//
//  DataProviderMock.swift
//  MoneyBoxTests
//
//  Created by Mohammed Ali on 27/10/2024.
//

import Foundation
import Networking

class DataProviderMock: DataProviderLogic {
    
    var loginResult: Result<LoginResponse, ErrorResponse>?
    var fetchAccountsResult: Result<AccountResponse, ErrorResponse>?
    var addMoneyResult: Result<OneOffPaymentResponse, ErrorResponse>?
    
    func addMoney(request: OneOffPaymentRequest, completion: @escaping ((Result<OneOffPaymentResponse, ErrorResponse>) -> Void)) {
        if let result = addMoneyResult {
            completion(result)
        }
    }
    
    func login(request: LoginRequest, completion: @escaping ((Result<LoginResponse, ErrorResponse>) -> Void)) {
        if let result = loginResult {
            completion(result)
        }
    }
    
    func fetchAccounts(completion: @escaping ((Result<AccountResponse, ErrorResponse>) -> Void)) {
        if let result = fetchAccountsResult {
            completion(result)
        }
    }
}
