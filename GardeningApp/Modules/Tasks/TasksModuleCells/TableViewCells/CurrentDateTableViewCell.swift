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
    var buttonTitle: String

    init(labelText: String, buttonTitle: String) {
        self.labelText = labelText
        self.buttonTitle = buttonTitle
    }
}

class CurrentDateTableViewCell: UITableViewCell, TaskTableViewCellItem {

    var delegate: TaskTableViewItemDelegate?

    func config(with data: Any) {
        guard let data = data as? CurrentDateTableViewCellModel else { return }
        contentView.backgroundColor = .light

        dateLabel.text = data.labelText
        todayButton.setTitle(data.buttonTitle, for: .normal)
    }
    
    private let dateLabel = CustomLabel(fontName: .body(), textColor: .dark)
    private let todayButton = CustomTextButton(text: "", bgColor: .dark)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews(){
        [dateLabel, todayButton].forEach { item in
            contentView.addSubview(item)
        }

        dateLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }

        todayButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.leading.equalTo(dateLabel.snp.trailing).offset(10)
            make.width.equalTo(80)
        }

        todayButton.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
    }

    @objc private func todayButtonTapped(){
        delegate?.todayButtonDidTap(self)
    }
}
