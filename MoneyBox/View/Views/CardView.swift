//
//  CardView.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 27/10/2024.
//

import Foundation
import UIKit

final class CardView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mutedBlue
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 32, weight: .bold)
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
        layer.cornerRadius = 16
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
    }
    
    func configure(title: String, amount: Double, image: UIImageView) {
        [titleLabel, amountLabel, image].forEach { addSubview($0) }
        
        titleLabel.text = title
        amountLabel.attributedText = amount.formatAsCurrencyAttributedString(
            primaryFontSize: 32,
            secondaryFontSize: 16
        )
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            amountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            image.widthAnchor.constraint(equalToConstant: 60),
            image.heightAnchor.constraint(equalToConstant: 60),
            
            heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}
