//
//  SessionManagerStubs.swift
//  MoneyBoxTests
//
//  Created by Mohammed Ali on 27/10/2024.
//

import Foundation
import Networking

class SessionManagerStub: SessionManagerProtocol {
    
    var sessionToken: String?
    var setUserTokenCalled = false
    var removeUserTokenCalled = false
    
    func setUserToken(_ token: String) {
        setUserTokenCalled = true
        sessionToken = token
    }
    
    func removeUserToken() {
        removeUserTokenCalled = true
    }
}
