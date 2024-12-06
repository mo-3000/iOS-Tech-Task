//
//  AccountDetailViewModel.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import Foundation
import Combine
import Networking

// MARK: - Protocols

protocol AccountDetailViewModelProtocol: ObservableObject {
    var didAddMoney: AnyPublisher<Double, Never> { get }
    var addMoneyFailure: AnyPublisher<String, Never> { get }
    func increaseAmount(by amount: Double) -> Double
    func addMoney(amount: Int)
    var account: ProductViewData { get }
}

// MARK: - Error Definitions

enum AccountError: LocalizedError {
    case invalidAmount
    case invalidProductID
    case networkError(String)
    case failedToRetrieveBalance
    
    var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "Amount must be greater than 0."
        case .invalidProductID:
            return "Invalid Product ID."
        case .networkError(let message):
            return message
        case .failedToRetrieveBalance:
            return "Failed to retrieve updated balance."
        }
    }
}

// MARK: - Validators

protocol AmountValidator {
    func validate(amount: Int) -> Result<Void, AccountError>
}

class DefaultAmountValidator: AmountValidator {
    func validate(amount: Int) -> Result<Void, AccountError> {
        amount > 0 ? .success(()) : .failure(.invalidAmount)
    }
}

// MARK: - ViewModel Implementation

final class AccountDetailViewModel: AccountDetailViewModelProtocol {
    
    // MARK: - Properties
    
    private let networkService: DataProviderLogic
    private let amountValidator: AmountValidator
    @Published private(set) var account: ProductViewData
    
    private let didAddMoneySubject = PassthroughSubject<Double, Never>()
    private let addMoneyFailureSubject = PassthroughSubject<String, Never>()
    
    var didAddMoney: AnyPublisher<Double, Never> {
        didAddMoneySubject.eraseToAnyPublisher()
    }
    
    var addMoneyFailure: AnyPublisher<String, Never> {
        addMoneyFailureSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(
        networkService: DataProviderLogic = DataProvider(),
        amountValidator: AmountValidator = DefaultAmountValidator(),
        account: ProductViewData
    ) {
        self.networkService = networkService
        self.amountValidator = amountValidator
        self.account = account
    }
    
    // MARK: - Public Methods
    
    func increaseAmount(by amount: Double) -> Double {
        let existingBalance = account.totalPlanValue ?? 0
        let updatedBalance = existingBalance + 10
        account.totalPlanValue = updatedBalance
        return updatedBalance
    }
    
    func addMoney(amount: Int) {
        switch amountValidator.validate(amount: amount) {
        case .success:
            guard let productID = account.productID else {
                addMoneyFailureSubject.send(AccountError.invalidProductID.localizedDescription)
                return
            }
            
            let paymentRequest = OneOffPaymentRequest(amount: amount, investorProductID: productID)
            
            networkService.addMoney(request: paymentRequest)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.addMoneyFailureSubject.send(AccountError.networkError(error.message ?? "Unknown error").localizedDescription)
                    }
                } receiveValue: { [weak self] response in
                    if let moneybox = response.moneybox {
                        self?.didAddMoneySubject.send(moneybox)
                    } else {
                        self?.addMoneyFailureSubject.send(AccountError.failedToRetrieveBalance.localizedDescription)
                    }
                }
                .store(in: &cancellables)
            
        case .failure(let error):
            addMoneyFailureSubject.send(error.localizedDescription)
        }
    }
}
