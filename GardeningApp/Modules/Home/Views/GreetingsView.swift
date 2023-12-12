//
//
// GardeningApp
// GreetingsView.swift
//
// Created by Alexander Kist on 12.12.2023.
//


import UIKit

class GreetingsView: UIView {

    private let greetingLabel = CustomLabel(fontName: UIFont.title())
    private let descriptionLabel = CustomLabel(fontName: UIFont.body(), text: "Flora is Here, your personal garden manager!")
    private let textStack = UIStackView()


    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews(){

        [greetingLabel, descriptionLabel].forEach { item  in
            textStack.addArrangedSubview(item)}

        textStack.axis = .vertical
        textStack.spacing = 10

        addSubview(textStack)

        textStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public func setText(with text: String){
        greetingLabel.text = text
    }
}

