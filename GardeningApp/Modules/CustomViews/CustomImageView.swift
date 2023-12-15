//
//
// GardeningApp
// CustomImageView.swift
// 
// Created by Alexander Kist on 14.12.2023.
//


import UIKit

final class CustomImageView: UIImageView {

    init(imageName: String) {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        image = UIImage(named: imageName)
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.accentLight.cgColor
    }
}
