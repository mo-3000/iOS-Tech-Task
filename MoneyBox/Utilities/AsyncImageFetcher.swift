//
//  AsyncImageFetcher.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit

protocol AsyncImageFetcherProtocol: AnyObject {
    func fetchImage(from urlString: String?) async throws -> UIImage
}

public enum AsyncImageFetcherError: LocalizedError {
    case networkFailure
    case corruptedData
    case invalidURL
    
    public var errorDescription: String? {
        switch self {
        case .networkFailure:
            return "Failed to download the image due to a network issue."
        case .corruptedData:
            return "The downloaded image data is corrupted and cannot be processed."
        case .invalidURL:
            return "The provided URL is invalid."
        }
    }
}

final class AsyncImageFetcher: AsyncImageFetcherProtocol {
    
    // MARK: - Properties
    private let urlSession: NetworkSessionProtocol
    
    // MARK: - Initialiser
    init(urlSession: NetworkSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // MARK: - Public Method
    func fetchImage(from urlString: String?) async throws -> UIImage {
        guard let urlString, let url = URL(string: urlString) else {
            throw AsyncImageFetcherError.invalidURL
        }
        
        let data: Data
        do {
            data = try await urlSession.fetchData(from: url)
        } catch {
            throw AsyncImageFetcherError.networkFailure
        }
        
        guard let image = UIImage(data: data) else {
            throw AsyncImageFetcherError.corruptedData
        }
        
        return image
    }
}
