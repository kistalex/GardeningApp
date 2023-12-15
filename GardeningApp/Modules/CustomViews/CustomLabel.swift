//
//
// GardeningApp
// CustomLabel.swift
// 
// Created by Alexander Kist on 11.12.2023.
//


import UIKit

final class CustomLabel: UILabel {

    init(fontName: UIFont, text: String? = nil, textColor: UIColor) {
        super.init(frame: .zero)
        self.textColor = textColor
        numberOfLines = 0
        font = fontName
        textAlignment = .center
        self.text = text

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
