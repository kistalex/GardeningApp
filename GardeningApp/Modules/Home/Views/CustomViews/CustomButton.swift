//
//
// GardeningApp
// CustomButton.swift
// 
// Created by Alexander Kist on 11.12.2023.
//


import UIKit

class CustomButton: UIButton {

    init(imageName: String, configImagePointSize: CGFloat, text: String? = nil, bgColor: UIColor? = nil){
        super.init(frame: .zero)
        let configuration = UIImage.SymbolConfiguration(pointSize: configImagePointSize)
        setImage(UIImage(systemName: imageName, withConfiguration: configuration), for: .normal)
        setTitle(text, for: .normal)
        setTitleColor(.accent, for: .normal)
        titleLabel?.font = UIFont.body()
        tintColor = .accent
        backgroundColor = bgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
