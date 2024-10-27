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
