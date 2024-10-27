//
//  NetworkSessionMock.swift
//  MoneyBoxTests
//
//  Created by Mohammed Ali on 27/10/2024.
//

import Foundation
import MoneyBox

class NetworkSessionMock: NetworkSessionProtocol {
    
    var result = Result<Data, AsyncImageFetcherError>.success(Data())
    
    func fetchData(from url: URL) async throws -> Data {
        try result.get()
    }
}
