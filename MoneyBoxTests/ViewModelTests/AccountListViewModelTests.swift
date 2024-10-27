//
//  AccountListViewModelTests.swift
//  MoneyBoxTests
//
//  Created by Mohammed Ali on 27/10/2024.
//

import XCTest
@testable import MoneyBox
@testable import Networking

final class AccountListViewModelTests: XCTestCase {
    
    private static let mockUser = LoginResponse.User(firstName: "John", lastName: "Smith")
    private static let mockData = AccountResponse(moneyboxEndOfTaxYear: "test", totalPlanValue: 100, totalEarnings: 0.0, totalContributionsNet: 0.0, totalEarningsAsPercentage: 0.0, productResponses: [.init(id: nil, assetBoxGlobalID: nil, planValue: nil, moneybox: nil, subscriptionAmount: nil, totalFees: nil, isSelected: nil, isFavourite: nil, collectionDayMessage: nil, wrapperID: nil, isCashBox: nil, pendingInstantBankTransferAmount: nil, assetBox: nil, product: nil, investorAccount: nil, personalisation: nil, contributions: nil, moneyboxCircle: nil, isSwitchVisible: nil, state: nil, dateCreated: nil)], accounts: nil)
    
    private var viewModel: AccountListViewModelProtocol!
    private var dataProviderMock: DataProviderMock!
    
    override func setUp() {
        super.setUp()
        dataProviderMock = DataProviderMock()
        viewModel = AccountListViewModel(dataProvider: dataProviderMock, user: AccountListViewModelTests.mockUser)
    }
    
    override func tearDown() {
        dataProviderMock = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchAccountSetsAccountHeaderViewData() throws {
        dataProviderMock.fetchAccountsResult = .success(AccountListViewModelTests.mockData)
        viewModel.fetchProducts()
        
        XCTAssertNotNil(viewModel.portfolioData.headerData)
    }
    
    func testFetchAccountSetsAccountViewData() throws {
        dataProviderMock.fetchAccountsResult = .success(AccountListViewModelTests.mockData)
        viewModel.fetchProducts()
        
        XCTAssertNotNil(viewModel.portfolioData.productDetails)
    }
    
    func testFetchAccountSetsWelcomeMessage() throws {
        dataProviderMock.fetchAccountsResult = .success(AccountListViewModelTests.mockData)
        viewModel.fetchProducts()
        
        XCTAssertEqual(viewModel.portfolioData.headerData?.welcomeMessage,  "\(viewModel.timeBasedGreeting()), \(AccountListViewModelTests.mockUser.firstName ?? "")")
    }
    
    func testFetchAccountErrorGivesErrorState() throws {
        dataProviderMock.fetchAccountsResult = .failure(.init(name: "", message: "Test Error", validationErrors: nil))
        let expectation = XCTestExpectation(description: "Error State")
        
        viewModel.loadingStatusDidUpdate = { state in
            switch state {
            case .error(let errorMessage):
                XCTAssertEqual(errorMessage, "Test Error")
                expectation.fulfill()
            case .inProgress:
                XCTFail("Should fail")
            case .completed:
                XCTFail("Should fail")
            }
        }
        
        viewModel.fetchProducts()
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchAccountSuccessGivesCompletedState() throws {
        dataProviderMock.fetchAccountsResult = .success(AccountListViewModelTests.mockData)
        let expectation = XCTestExpectation(description: "Completed State")
        
        viewModel.loadingStatusDidUpdate = { state in
            switch state {
            case .error:
                XCTFail("Should fail")
            case .inProgress:
                XCTFail("Should fail")
            case .completed:
                XCTAssertEqual(self.viewModel.portfolioData.headerData?.totalPlanAmount, AccountListViewModelTests.mockData.totalPlanValue)
                expectation.fulfill()
            }
        }
        
        viewModel.fetchProducts()
        
        wait(for: [expectation], timeout: 5)
    }
}
