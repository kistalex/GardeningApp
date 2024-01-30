//
//
// GardeningApp
// AddTaskButtonTableViewCell.swift
// 
// Created by Alexander Kist on 15.01.2024.
//


import Foundation
import UIKit


class AddTaskButtonTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: AddTaskButtonTableViewCellModel.self)

    var buttonImageName: String
    var imagePointSize: CGFloat

    init(imageName: String, imagePointSize: CGFloat) {
        self.buttonImageName = imageName
        self.imagePointSize = imagePointSize
    }
}

final class AddTaskButtonTableViewCell: UITableViewCell, TaskTableViewCellItem {

    weak var delegate: TaskTableViewItemDelegate?

    func config(with data: Any) {
        guard let data = data as? AddTaskButtonTableViewCellModel else { return }
        let configuration = UIImage.SymbolConfiguration(pointSize: data.imagePointSize)
        contentView.backgroundColor = Constants.contentViewBgColor
        actionButton.setImage(UIImage(systemName: data.buttonImageName, withConfiguration: configuration), for: .normal)
        actionButton.tintColor = Constants.actionButtonTintColor
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private enum Constants {
        static let actionButtonSize: CGFloat = 45
        static let verticalInsets: CGFloat = 10
        static let cornerRadiusDivider: CGFloat = 2
        static let contentViewBgColor: UIColor = .light
        static let actionButtonTintColor: UIColor = .dark
    }

    private let actionButton = UIButton(type: .system)

    private func setupButton() {
        contentView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(Constants.verticalInsets)
            make.centerX.equalTo(contentView)
            make.size.equalTo(Constants.actionButtonSize)
        }
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }

    @objc private func actionButtonTapped(){
        delegate?.buttonCellDidTap(self)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        actionButton.layer.cornerRadius = actionButton.frame.size.height / Constants.cornerRadiusDivider
    }
}


