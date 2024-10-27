//
//  UIColor+Extensions.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit

extension UIColor {
    static let accent = UIColor(named: "AccentColor")
    static let lightBorder = UIColor(red: 0.69, green: 0.80, blue: 0.83, alpha: 1.00)
    static let mutedBlue = UIColor(red: 0.38, green: 0.62, blue: 0.66, alpha: 1.00)
    static let deepSea = UIColor(red: 0.00, green: 0.26, blue: 0.38, alpha: 1.00)
    static let oceanBlue = UIColor(red: 0.28, green: 0.55, blue: 0.61, alpha: 1.00)
    
    // MARK: - Hex Color Initialiser
    convenience init?(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        guard Scanner(string: hexString).scanHexInt64(&rgbValue) else {
            return nil
        }
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
