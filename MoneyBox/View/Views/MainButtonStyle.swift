//
//  MainButtonStyle.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 05/12/2024.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var foregroundColor: Color = .white

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(backgroundColor)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
