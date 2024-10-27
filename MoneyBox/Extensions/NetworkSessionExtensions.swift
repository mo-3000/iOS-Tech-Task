//
//  NetworkSessionExtensions.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import Foundation

// MARK: - NetworkSessionProtocol

public protocol NetworkSessionProtocol {
    func fetchData(from url: URL) async throws -> Data
}

extension URLSession: NetworkSessionProtocol {
    public func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await self.data(from: url)
        return data
    }
}

// MARK: - NetworkDataTaskProtocol

protocol NetworkDataTask {
    func start()
}

extension URLSessionDataTask: NetworkDataTask {
    func start() {
        self.resume()
    }
}
