//
//  AccountViewData.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import Foundation
import Networking

struct UserAccountData {
    var headerData: AccountSummaryData?
    var productDetails: [ProductViewData]?
}

struct AccountSummaryData {
    var totalContributions: Double?
    var earningsPercentage: Double?
    var welcomeMessage: String
    var totalPlanAmount: Double?
    var netEarnings: Double?
}

struct TransactionAction {
    let description: String
    let formattedAmount: String
}

extension AccountResponse {
    func toSummaryData(welcomeMessage: String) -> AccountSummaryData {
        return AccountSummaryData(
            totalContributions: totalContributionsNet,
            earningsPercentage: totalEarningsAsPercentage,
            welcomeMessage: welcomeMessage,
            totalPlanAmount: totalPlanValue,
            netEarnings: totalEarnings
        )
    }
}
