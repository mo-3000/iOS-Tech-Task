//
//  ProductViewData.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import Foundation
import Networking

// MARK: - ProductViewData

struct ProductViewData: Hashable {
    let productID: Int?
    let productName: String?
    let displayName: String?
    
    let productLogoURL: String?
    let colorCodeHex: String?
    
    var totalPlanValue: Double?
    var netContributions: Double?
    let availableMoneyBox: Double?
    let totalEarnings: Double?
    let earningsPercentage: Double?
    
    let isFavorite: Bool?
    let assetTitle: String?
}

// MARK: - ProductResponse Mapping

extension ProductResponse {
    var toProductViewData: ProductViewData {
        return ProductViewData(
            productID: id,
            productName: product?.name,
            displayName: product?.friendlyName,
            
            productLogoURL: product?.logoURL,
            colorCodeHex: product?.productHexCode,
            
            totalPlanValue: planValue,
            netContributions: investorAccount?.contributionsNet,
            availableMoneyBox: moneybox,
            totalEarnings: investorAccount?.earningsNet,
            earningsPercentage: investorAccount?.earningsAsPercentage,
            
            isFavorite: isFavourite,
            assetTitle: assetBox?.title
        )
    }
}

