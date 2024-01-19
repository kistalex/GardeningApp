//
//
// GardeningApp
// GreetingsTableViewCell.swift
// 
// Created by Alexander Kist on 23.01.2024.
//


import UIKit
import SnapKit

class GreetingsTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: GreetingsTableViewCellModel.self)

    var greetingText: String
    var introductionText: String

    init(greetingText: String, introductionText: String) {
        self.greetingText = greetingText
        self.introductionText = introductionText
    }

}

class GreetingsTableViewCell: UITableViewCell, HomeTableViewCellItem {
    weak var delegate: HomeTableViewCellItemDelegate?

    func config(with data: Any) {
        guard let data = data as? GreetingsTableViewCellModel else { return }
        contentView.backgroundColor = .light
        greetingLabel.text = data.greetingText
        introductionLabel.text = data.introductionText
    }

    private let greetingLabel = CustomLabel(fontName: UIFont.title(), textColor: .dark)
    private let introductionLabel = CustomLabel(fontName: UIFont.body(), textColor: .dark)
    private let textStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews(){

        [greetingLabel, introductionLabel].forEach { item  in
            textStack.addArrangedSubview(item)}

        textStack.axis = .vertical
        textStack.spacing = 10

        contentView.addSubview(textStack)

        textStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
    }

}

