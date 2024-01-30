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
        contentView.backgroundColor = Constants.contentViewBgColor
        header.text = data.headerText
        addPlantButton.setTitle(data.buttonTitle, for: .normal)
        addPlantButton.titleLabel?.font = .body()
        addPlantButton.setImage(UIImage(systemName: data.buttonImageName), for: .normal)
        addPlantButton.tintColor = .dark
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private enum Constants {
        static let dividerLineTopInset: CGFloat = 10
        static let dividerLineHorizontalInset: CGFloat = 20
        static let dividerLineHeight: CGFloat = 1
        static let stackViewTopInset: CGFloat = 10
        static let stackViewHorizontalInset: CGFloat = 20
        static let stackViewBottomInset: CGFloat = 10
        static let contentViewBgColor: UIColor = .light
        static let headerFont = UIFont.title2()
        static let textColor: UIColor = .dark
    }
    

    private let header = CustomLabel(fontName: Constants.headerFont, text: "", textColor: Constants.textColor)
    private let addPlantButton = UIButton(type: .system)
    private let dividerLine = UIView()
    private let stackView = UIStackView()

    private func setupViews(){
        contentView.addSubview(stackView)
        contentView.addSubview(dividerLine)

        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        stackView.addArrangedSubview(header)
        stackView.addArrangedSubview(addPlantButton)


        dividerLine.backgroundColor = .dark

        dividerLine.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.dividerLineTopInset)
            make.horizontalEdges.equalToSuperview().inset(Constants.dividerLineHorizontalInset)
            make.height.equalTo(Constants.dividerLineHeight)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(Constants.stackViewTopInset)
            make.horizontalEdges.equalToSuperview().inset(Constants.stackViewHorizontalInset)
            make.bottom.equalToSuperview().inset(Constants.stackViewBottomInset)
        }

        addPlantButton.addTarget(self, action: #selector(didTapAddPlant), for: .touchUpInside)
    }

    @objc private func didTapAddPlant(){
        delegate?.didTapAddNewPlantButton(self)
    }
}


