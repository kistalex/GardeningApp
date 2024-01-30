//
//
// GardeningApp
// SaveTaskButtonTableViewCell.swift
// 
// Created by Alexander Kist on 09.01.2024.
//


import UIKit

final class SaveTaskButtonTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: SaveTaskButtonTableViewCellModel.self)

    var buttonTitle: String

    init(title: String) {
        self.buttonTitle = title
    }
}

final class SaveTaskButtonTableViewCell: UITableViewCell, AddTaskTableViewCellItem {

    weak var delegate: AddTaskTableViewItemDelegate?
    
    func config(with data: Any) {
        guard let data = data as? SaveTaskButtonTableViewCellModel else { return }
        contentView.backgroundColor = Constants.contentViewBgColor
        actionButton.titleLabel?.font = Constants.actionButtonTitleFont
        actionButton.setTitle(data.buttonTitle, for: .normal)
        actionButton.setTitleColor(Constants.actionButtonTitleColor, for: .normal)
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
        static let actionButtonHeight: CGFloat = 50
        static let actionButtonWidth: CGFloat = 150
        static let cornerRadiusDivider: CGFloat = 2
        static let actionButtonTopInset: CGFloat = 10
        static let actionButtonBottomInset: CGFloat = 10
        static let contentViewBgColor: UIColor = .light
        static let actionButtonTitleColor: UIColor = .light
        static let actionButtonTitleFont = UIFont.body()
        static let actionButtonBgColor: UIColor = .dark
    }

    private let actionButton = UIButton(type: .system)

    private func setupButton() {
        contentView.addSubview(actionButton)
        actionButton.backgroundColor = Constants.actionButtonBgColor
        actionButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.actionButtonTopInset)
            make.bottom.equalToSuperview().inset(Constants.actionButtonBottomInset)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.actionButtonWidth)
            make.height.equalTo(Constants.actionButtonHeight)
        }
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }

    @objc private func actionButtonTapped(){
        delegate?.buttonCellDidTapped(self)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        actionButton.layer.cornerRadius = actionButton.frame.size.height / Constants.cornerRadiusDivider
    }
}
