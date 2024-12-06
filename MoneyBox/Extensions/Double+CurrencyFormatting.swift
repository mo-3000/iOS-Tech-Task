//
//  Double+CurrencyFormatting.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit

extension Double {
    
    func formatAsCurrencyAttributedString(
        primaryFontSize: CGFloat,
        secondaryFontSize: CGFloat
    ) -> NSAttributedString {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 2
        
        let currencyString = currencyFormatter.string(from: NSNumber(value: self)) ?? ""
        
        return currencyString.toAttributedCurrencyFormat(
            mainFontSize: primaryFontSize,
            fractionFontSize: secondaryFontSize
        )
    }
}

private extension String {
    func toAttributedCurrencyFormat(
        mainFontSize: CGFloat,
        fractionFontSize: CGFloat
    ) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        
        if let decimalSeparatorRange = self.range(of: Locale.current.decimalSeparator ?? ".") {
            let integerPartRange = NSRange(self.startIndex..<decimalSeparatorRange.lowerBound, in: self)
            let fractionalPartRange = NSRange(decimalSeparatorRange.lowerBound..<self.endIndex, in: self)
            
            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: mainFontSize), range: integerPartRange)
            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: fractionFontSize), range: fractionalPartRange)
        } else {
            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: mainFontSize), range: NSRange(location: 0, length: self.count))
        }
        
        return attributedText
    }
}
import SwiftUI

extension Double {
    func formatAsCurrencyAttributedStringSwiftUI(
        primaryFontSize: CGFloat,
        secondaryFontSize: CGFloat
    ) -> AttributedString {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 2

        let currencyString = currencyFormatter.string(from: NSNumber(value: self)) ?? ""

        return currencyString.toAttributedCurrencyFormat(
            mainFontSize: primaryFontSize,
            fractionFontSize: secondaryFontSize
        )
    }
}

private extension String {
    func toAttributedCurrencyFormat(
        mainFontSize: CGFloat,
        fractionFontSize: CGFloat
    ) -> AttributedString {
        var attributedText = AttributedString(self)

        let decimalSeparator = Locale.current.decimalSeparator ?? "."

        if let decimalRange = self.range(of: decimalSeparator) {
            let integerPart = String(self[self.startIndex..<decimalRange.lowerBound])
            let fractionalPart = String(self[decimalRange.lowerBound..<self.endIndex])

            if let integerRange = attributedText.range(of: integerPart) {
                attributedText[integerRange].font = .system(size: mainFontSize, weight: .medium)
            }

            if let fractionalRange = attributedText.range(of: fractionalPart) {
                attributedText[fractionalRange].font = .system(size: fractionFontSize, weight: .medium)
            }
        } else {
            attributedText.font = .system(size: mainFontSize, weight: .medium)
        }

        return attributedText
    }
}
