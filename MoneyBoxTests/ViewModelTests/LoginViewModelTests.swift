//
//  LoginViewModelTest.swift
//  MoneyBoxTests
//
//  Created by Mohammed Ali on 27/10/2024.
//

import XCTest
@testable import MoneyBox
@testable import Networking

final class LoginViewModelTests: XCTestCase {
    
    private static let mockData = LoginResponse(session: .init(
        bearerToken: "hiudqesi8h3uew8ubqdewsd8udqwe89huo3weh8"),
                                                user: .init(
                                                    firstName: "John",
                                                    lastName: "Smith"
                                                )
    )
    
    private var viewModel: LoginViewModelProtocol!
    private var dataProviderMock: DataProviderMock!
    private var sessionManagerStub: SessionManagerStub!
    
    override func setUp() {
        super.setUp()
        dataProviderMock = DataProviderMock()
        sessionManagerStub = SessionManagerStub()
        viewModel = LoginViewModel(provider: dataProviderMock, manager: sessionManagerStub)
    }
    
    override func tearDown() {
        dataProviderMock = nil
        sessionManagerStub = nil
        viewModel = nil
        super.tearDown()
    }
    
    
    func testLoginWithInvalidEmailAndPasswordThrowsUnknownError() {
        let expectation = XCTestExpectation(description: "Unknown error")
        expectation.assertForOverFulfill = true
        
        dataProviderMock.loginResult = .failure(ErrorResponse.init(name: nil, message: nil, validationErrors: [.init(name: nil, message: nil)]))
        
        viewModel.onSuccess = { user in
            XCTFail("Shouldn't succeed")
        }
        
        viewModel.onError = { error in
            XCTAssertEqual(error.loginError, LoginError.unknown)
            expectation.fulfill()
        }
        
        viewModel.login(email: "test", password: "test")
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSuccessfulLoginSetsUserToken() {
        let expectation = XCTestExpectation(description: "Set user token")
        
        dataProviderMock.loginResult = .success(LoginViewModelTests.mockData)
        XCTAssertFalse(sessionManagerStub.setUserTokenCalled)
        
        viewModel.onSuccess = { user in
            XCTAssertTrue(self.sessionManagerStub.setUserTokenCalled)
            expectation.fulfill()
        }
        
        viewModel.onError = { error in
            XCTFail("Shouldn't give error")
        }
        
        viewModel.login(email: "test@moneybox.com", password: "password")
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testInvalidEmailThrowsEmailError() {
        let expectation = XCTestExpectation(description: "Login error handled")
        
        dataProviderMock.loginResult = .failure(ErrorResponse.init(name: nil, message: nil, validationErrors: [.init(name: "Email", message: nil)]))
        
        viewModel.onSuccess = { user in
            XCTFail("Should throw invalid email")
        }
        
        viewModel.onError = { error in
            XCTAssertEqual(error.loginError, LoginError.email)
            expectation.fulfill()
        }
        
        viewModel.login(email: "", password: "")
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testInvalidPasswordThrowsPasswordError() {
        let expectation = XCTestExpectation(description: "Password error handled")
        expectation.assertForOverFulfill = true
        
        dataProviderMock.loginResult = .failure(ErrorResponse.init(name: nil, message: nil, validationErrors: [.init(name: "Password", message: nil)]))
        
        viewModel.onSuccess = { user in
            XCTFail("Should throw invalid password")
        }
        
        viewModel.onError = { error in
            XCTAssertEqual(error.loginError, LoginError.password)
            expectation.fulfill()
        }
        
        viewModel.login(email: "test@gmail.com", password: "")
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testLogInGivesSessionToken() {
        let expectation = XCTestExpectation(description: "Session token is set")
        
        dataProviderMock.loginResult = .success(LoginViewModelTests.mockData)
        XCTAssertFalse(sessionManagerStub.setUserTokenCalled)
        
        viewModel.onSuccess = { user in
            XCTAssertEqual(self.sessionManagerStub.sessionToken, LoginViewModelTests.mockData.session.bearerToken)
            expectation.fulfill()
        }
        
        viewModel.onError = { error in
            XCTFail("Shouldn't give an error")
        }
        
        viewModel.login(email: "test@moneybox.com", password: "password")
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSuccessfulLoginGivesUser() {
        let expectation = XCTestExpectation(description: "Successful login gives user")
        
        dataProviderMock.loginResult = .success(LoginViewModelTests.mockData)
        
        viewModel.onSuccess = { user in
            XCTAssertEqual(user.firstName, "John")
            XCTAssertEqual(user.lastName, "Smith")
            expectation.fulfill()
        }
        
        viewModel.onError = { error in
            XCTFail("Shouldn't fail")
        }
        
        viewModel.login(email: "test@moneybox.com", password: "password")
        
        wait(for: [expectation], timeout: 5)
    }
    
}
