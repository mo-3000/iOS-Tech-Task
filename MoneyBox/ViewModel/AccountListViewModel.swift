//
//  AccountListViewModel.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//


import UIKit
import Networking

enum LoadingStatus {
    case inProgress
    case completed
    case error(String?)
}

protocol AccountListViewModelProtocol: AnyObject {
    var loadingStatusDidUpdate: ((LoadingStatus) -> Void)? { get set }
    var portfolioData: UserAccountData { get }
    var dataProvider: DataProviderLogic { get }
    func timeBasedGreeting() -> String
    func fetchProducts()
}

final class AccountListViewModel: AccountListViewModelProtocol {
    // MARK: - Properties
    let dataProvider: DataProviderLogic
    private let user: LoginResponse.User
    private var loadingState: LoadingStatus = .inProgress {
        didSet {
            loadingStatusDidUpdate?(loadingState)
        }
    }
    
    var loadingStatusDidUpdate: ((LoadingStatus) -> Void)?
    var portfolioData = UserAccountData() {
        didSet {
            loadingState = .completed
        }
    }
    
    // MARK: - Lifecycle
    init(
        dataProvider: DataProviderLogic = DataProvider(),
        user: LoginResponse.User
    ) {
        self.dataProvider = dataProvider
        self.user = user
    }
    
    // MARK: - Public Methods
    func fetchProducts() {
        self.loadingState = .inProgress
        
        dataProvider.fetchAccounts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.processPortfolioData(with: response)
            case .failure(let error):
                self.loadingState = .error(error.message)
            }
        }
    }
    
    func timeBasedGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            return "Good morning"
        case 12..<18:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }
    
    // MARK: - Private Methods
    private func processPortfolioData(with response: AccountResponse) {
        let summaryData = response.toSummaryData(welcomeMessage: personalisedGreeting)
        let investments = response.productResponses?.map({ $0.toProductViewData })
        
        portfolioData = UserAccountData(
            headerData: summaryData,
            productDetails: investments
        )
    }
    
    private var personalisedGreeting: String {
        guard let name = user.firstName else { return "" }
        return "\(timeBasedGreeting()), \(name)"
    }
}
