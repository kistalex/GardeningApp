//
//
// GardeningApp
// CurrentDateTableViewCell.swift
//
// Created by Alexander Kist on 17.01.2024.
//


import Foundation
import UIKit

class CurrentDateTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: CurrentDateTableViewCellModel.self)

    var labelText: String
    var todayButtonTitle: String

    init(labelText: String, todayButtonTitle: String) {
        self.labelText = labelText
        self.todayButtonTitle = todayButtonTitle
    }
}

class CurrentDateTableViewCell: UITableViewCell, TaskTableViewCellItem {

    var delegate: TaskTableViewItemDelegate?

    func config(with data: Any) {
        guard let data = data as? CurrentDateTableViewCellModel else { return }
        contentView.backgroundColor = Constants.contentViewBgColor
        dateLabel.text = data.labelText
        todayButton.setTitle(data.todayButtonTitle, for: .normal)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private enum Constants {
        static let verticalInsets: CGFloat = 10
        static let horizontalInsets: CGFloat = 10
        static let buttonWidthConstraint: CGFloat = 80
        static let textFont = UIFont.body()
        static let textColor: UIColor = .dark
        static let buttonBgColor: UIColor = .dark
        static let contentViewBgColor: UIColor = .light
    }

    private let dateLabel = CustomLabel(fontName: Constants.textFont, textColor: Constants.textColor)

    private let todayButton = CustomTextButton(text: "", bgColor: Constants.buttonBgColor)
    
    private func setupViews(){
        [dateLabel, todayButton].forEach { item in
            contentView.addSubview(item)
        }

        dateLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constants.verticalInsets)
            make.centerX.equalToSuperview()
        }

        todayButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.leading.equalTo(dateLabel.snp.trailing).offset(Constants.horizontalInsets)
            make.width.equalTo(Constants.buttonWidthConstraint)
        }

        todayButton.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
    }

    @objc private func todayButtonTapped(){
        delegate?.todayButtonDidTap(self)
    }
}
