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

    private let actionButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        contentView.addSubview(actionButton)
        actionButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        actionButton.tintColor = .dark
        actionButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(10)
            make.centerX.equalTo(contentView)
            make.size.equalTo(45)
        }

        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }

    @objc private func actionButtonTapped(){
        delegate?.buttonCellDidTap(self)
    }


    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        actionButton.layer.cornerRadius = actionButton.frame.size.height / 2
    }

    func config(with data: Any) {
        guard let data = data as? AddTaskButtonTableViewCellModel else { return }
        let configuration = UIImage.SymbolConfiguration(pointSize: data.imagePointSize)
        contentView.backgroundColor = .light
        actionButton.setImage(UIImage(systemName: data.buttonImageName, withConfiguration: configuration), for: .normal)
    }
}


