//
//  AccountDetailViewModel.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import Foundation
import Networking

protocol AccountDetailViewModelProtocol {
    var didAddMoney: ((Double?) -> Void)? { get set }
    var addMoneyFailure: ((String?) -> Void)? { get set }
    func increaseAmount(amount: Double) -> Double
    func addMoney(amount: Int)
    var account: ProductViewData { get set }
}

final class AccountDetailViewModel: AccountDetailViewModelProtocol {
    
    // MARK: - Properties
    private let networkService: DataProviderLogic
    var account: ProductViewData
    
    // MARK: - Callbacks
    var didAddMoney: ((Double?) -> Void)?
    var addMoneyFailure: ((String?) -> Void)?
    
    // MARK: - Initialisation
    init(
        networkService: DataProviderLogic = DataProvider(),
        account: ProductViewData
    ) {
        self.networkService = networkService
        self.account = account
    }
    
    // MARK: - Public Methods
    func increaseAmount(amount: Double) -> Double {
        let existingBalance = account.totalPlanValue ?? 0
        let updatedBalance = existingBalance + 10
        account.totalPlanValue = updatedBalance
        return updatedBalance
    }
    
    func addMoney(amount: Int) {
        guard let productID = account.productID else { return }
        
        let paymentRequest = OneOffPaymentRequest(
            amount: amount,
            investorProductID: productID
        )
        
        networkService.addMoney(request: paymentRequest) { [weak self] result in
            switch result {
            case .success(let response):
                self?.didAddMoney?(response.moneybox)
            case .failure(let error):
                self?.addMoneyFailure?(error.message)
            }
        }
    }
}
