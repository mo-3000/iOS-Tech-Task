//
//  PillView.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 27/10/2024.
//

import Foundation
import UIKit

final class PillView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .systemGray
        layer.cornerRadius = 12
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    func setText(_ text: String) {
        label.text = text
    }
    
    func setColor(_ color: UIColor) {
        backgroundColor = color.withAlphaComponent(0.15)
        label.textColor = color
    }
}
