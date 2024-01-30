//
//
// GardeningApp
// SavePlantButtonTableViewCell.swift
// 
// Created by Alexander Kist on 21.01.2024.
//


import UIKit

class SavePlantButtonTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: SavePlantButtonTableViewCellModel.self)

    var buttonTitle: String

    init(buttonTitle: String) {
        self.buttonTitle = buttonTitle
    }
}

final class SavePlantButtonTableViewCell: UITableViewCell, AddPlantTableViewCellItem {

    weak var delegate: AddPlantTableViewItemDelegate?
    
    func config(with data: Any) {
        guard let data = data as? SavePlantButtonTableViewCellModel else { return }
        contentView.backgroundColor = Constants.contentViewBgColor
        actionButton.titleLabel?.font = .body()
        actionButton.setTitle(data.buttonTitle, for: .normal)
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
    }

    private let actionButton = UIButton(type: .system)

    private func setupButton() {
        contentView.addSubview(actionButton)
        actionButton.setTitleColor(.light, for: .normal)
        actionButton.backgroundColor = .dark
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
        delegate?.didTapSaveButton(self)
    }


    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        actionButton.layer.cornerRadius = actionButton.frame.size.height / Constants.cornerRadiusDivider
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        actionButton.layer.cornerRadius = actionButton.frame.size.height / Constants.cornerRadiusDivider
    }
}
