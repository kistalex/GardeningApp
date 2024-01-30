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
        contentView.backgroundColor = Constants.contentViewBgColor
        greetingLabel.text = data.greetingText
        introductionLabel.text = data.introductionText
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private enum Constants {
        static let greetingTextFont = UIFont.title()
        static let introductionTextFont = UIFont.body()
        static let textAssetColor: UIColor = .dark
        static let stackSpacing: CGFloat = 10
        static let stackHorizontalInset: CGFloat = 20
        static let stackBottomInset: CGFloat = 10
        static let contentViewBgColor: UIColor = .light
    }

    private let greetingLabel = CustomLabel(fontName: Constants.greetingTextFont, textColor: Constants.textAssetColor)
    private let introductionLabel = CustomLabel(fontName: Constants.introductionTextFont, textColor: Constants.textAssetColor)
    private let textStack = UIStackView()



    private func setupViews(){

        [greetingLabel, introductionLabel].forEach { item  in
            textStack.addArrangedSubview(item)}

        textStack.axis = .vertical
        textStack.spacing = Constants.stackSpacing

        contentView.addSubview(textStack)

        textStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.stackHorizontalInset)
            make.bottom.equalToSuperview().inset(Constants.stackBottomInset)
        }
    }

}

