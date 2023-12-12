//
//
// GardeningApp
// CustomButton.swift
// 
// Created by Alexander Kist on 11.12.2023.
//


import UIKit

class CustomButton: UIButton {

    init(imageName: String, configImagePointSize: CGFloat, text: String? = nil){
        super.init(frame: .zero)
        let configuration = UIImage.SymbolConfiguration(pointSize: configImagePointSize)
        setImage(UIImage(systemName: imageName, withConfiguration: configuration), for: .normal)
        setTitle(text, for: .normal)
        tintColor = .tint
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
