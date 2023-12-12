//
//
// GardeningApp
// CustomLabel.swift
// 
// Created by Alexander Kist on 11.12.2023.
//


import UIKit

final class CustomLabel: UILabel {

    init(fontName: UIFont, text: String? = nil) {
        super.init(frame: .zero)
        textColor = .accent
        numberOfLines = 0
        font = fontName
        textAlignment = .center
        self.text = text

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
