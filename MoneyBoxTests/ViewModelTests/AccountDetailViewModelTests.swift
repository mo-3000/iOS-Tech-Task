//
//  AccountDetailViewModelTests.swift
//  MoneyBoxTests
//
//  Created by Mohammed Ali on 27/10/2024.
//

import XCTest
@testable import MoneyBox
@testable import Networking

final class AccountDetailsViewModelTests: XCTestCase {
    
    private static let mockAccount = ProductViewData(productID: 0, productName: "", displayName: "", productLogoURL: "", colorCodeHex: "", availableMoneyBox: 0, totalEarnings: 100, earningsPercentage: 0, isFavorite: false, assetTitle: "")
    private static let mockData = OneOffPaymentResponse(moneybox: 100)
    
    private var viewModel: AccountDetailViewModelProtocol!
    private var dataProviderMock: DataProviderMock!
    
    override func setUp() {
        super.setUp()
        dataProviderMock = DataProviderMock()
        viewModel = AccountDetailViewModel(networkService: dataProviderMock, account: AccountDetailsViewModelTests.mockAccount)
    }
    
    override func tearDown() {
        dataProviderMock = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFailureMoneyAdd() {
        dataProviderMock.addMoneyResult = .failure(.init(name: "", message: "Test Error", validationErrors: nil))
        let expectation = XCTestExpectation(description: "Add money failed")
        
        viewModel.didAddMoney = { amount in
            XCTFail("Shouldn't be successful")
        }
        
        viewModel.addMoneyFailure = { error in
            XCTAssertEqual(error, "Test Error")
            expectation.fulfill()
        }
        
        viewModel.addMoney(amount: 10)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSuccessfulMoneyAdd() {
        dataProviderMock.addMoneyResult = .success(AccountDetailsViewModelTests.mockData)
        let expectation = XCTestExpectation(description: "Add money successfull")
        
        viewModel.didAddMoney = { amount in
            XCTAssertEqual(amount, 100)
            expectation.fulfill()
        }
        
        viewModel.addMoneyFailure = { error in
            XCTFail("Shouldn't fail")
        }
        
        viewModel.addMoney(amount: 10)
        
        wait(for: [expectation], timeout: 5)
    }
}
