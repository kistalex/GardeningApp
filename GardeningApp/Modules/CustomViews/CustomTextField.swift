//
//
// GardeningApp
// CustomTextField.swift
//
// Created by Alexander Kist on 12.12.2023.
//


import UIKit

final class CustomTextField: UITextField {
    
    enum CustomTextFieldType {
        case name
        case age
    }
    private let tFieldType: CustomTextFieldType
    
    init(tFieldType: CustomTextFieldType) {
        self.tFieldType = tFieldType
        super.init(frame: .zero)
        autocorrectionType = .no
        leftViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.size.height))
        
        switch tFieldType {
        case .name:
            placeholder = "Input plant name here"
            returnKeyType = .continue
        case .age:
            placeholder = "Input plant age here"
            returnKeyType = .continue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.accentLight.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error to init TextField")
    }
}

