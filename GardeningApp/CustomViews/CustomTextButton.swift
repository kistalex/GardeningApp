//
//
// GardeningApp
// CustomTextButton.swift
// 
// Created by Alexander Kist on 12.12.2023.
//


import UIKit

final class CustomTextButton: UIButton {

    init(text: String? = "", bgColor: UIColor){
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        setTitleColor(.light, for: .normal)
        titleLabel?.font = UIFont.body()
        backgroundColor = .dark
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }


}
