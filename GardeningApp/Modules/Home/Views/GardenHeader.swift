//
//
// GardeningApp
// GardenHeader.swift
//
// Created by Alexander Kist on 12.12.2023.
//


import UIKit

final class GardenHeader: UIView {

    weak var delegate: HomeModuleEventsDelegate?

    private let header = CustomLabel(fontName: UIFont.title2(), text: "My Garden", textColor: .accentLight)
    private let addPlantButton = CustomImageButton(imageName: "plus.circle.fill", configImagePointSize: 20, text: "Add new plant")
    private let dividerLine = UIView()

    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews(){
        setupLine()
        setupStackView()
    }

    private func setupLine() {
        addSubview(dividerLine)
        dividerLine.backgroundColor = .accentLight

        dividerLine.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    private func setupStackView(){
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        stackView.addArrangedSubview(header)
        stackView.addArrangedSubview(addPlantButton)
        
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }

        addPlantButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    //MARK: - Selectors
    @objc private func handleTap(){
        delegate?.didTapAddNewPlantButton(sender: self)
    }
}
