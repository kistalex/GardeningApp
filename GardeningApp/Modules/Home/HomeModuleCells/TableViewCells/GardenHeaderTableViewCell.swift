//
//
// GardeningApp
// GardenHeaderTableViewCell.swift
// 
// Created by Alexander Kist on 23.01.2024.
//


import UIKit
import SnapKit

class GardenHeaderTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: GardenHeaderTableViewCellModel.self)

    var headerText: String
    var buttonImageName: String
    var buttonTitle: String

    init(headerText: String, buttonImageName: String, buttonTitle: String) {
        self.headerText = headerText
        self.buttonImageName = buttonImageName
        self.buttonTitle = buttonTitle
    }
}

class GardenHeaderTableViewCell: UITableViewCell, HomeTableViewCellItem {
    var delegate: HomeTableViewCellItemDelegate?

    func config(with data: Any) {
        guard let data = data as? GardenHeaderTableViewCellModel else { return }
        contentView.backgroundColor = .light
        header.text = data.headerText
        addPlantButton.setTitle(data.buttonTitle, for: .normal)
        addPlantButton.titleLabel?.font = .body()
        addPlantButton.setImage(UIImage(systemName: data.buttonImageName), for: .normal)
        addPlantButton.tintColor = .dark
    }


    private let header = CustomLabel(fontName: UIFont.title2(), text: "My Garden", textColor: .dark)
    private let addPlantButton = UIButton(type: .system)
    private let dividerLine = UIView()

    private let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews(){
        contentView.addSubview(stackView)
        contentView.addSubview(dividerLine)

        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        stackView.addArrangedSubview(header)
        stackView.addArrangedSubview(addPlantButton)


        dividerLine.backgroundColor = .dark

        dividerLine.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }

        addPlantButton.addTarget(self, action: #selector(didTapAddPlant), for: .touchUpInside)
    }
    
    @objc private func didTapAddPlant(){
        delegate?.didTapAddNewPlantButton(self)
    }
}


