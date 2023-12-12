//
//
// GardeningApp
// ButtonView.swift
// 
// Created by Alexander Kist on 12.12.2023.
//


import UIKit

class ButtonView: UIView {

    weak var delegate: HomeModuleEventsDelegate?

    private let searchButton = CustomButton(imageName: "magnifyingglass", configImagePointSize: 20)
    private let notificationButton = CustomButton(imageName: "bell", configImagePointSize: 20)
    private var buttonStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {
        
        [searchButton, notificationButton].forEach { item  in
            buttonStack.addArrangedSubview(item)}

        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalSpacing

        addSubview(buttonStack)

        buttonStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchButton.addTarget(self, action: #selector(handleSearchButtonTap), for: .touchUpInside)
        notificationButton.addTarget(self, action: #selector(handleNotificationButtonTap), for: .touchUpInside)
    }
    
    //MARK: - Selectors
    @objc private func handleSearchButtonTap(){
        delegate?.didTapSearchButton(sender: self)
    }

    @objc private func handleNotificationButtonTap(){
        delegate?.didTapNotificationButton(sender: self)
    }
}
