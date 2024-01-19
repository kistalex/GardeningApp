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
        actionButton.setTitleColor(.light, for: .normal)
        actionButton.backgroundColor = .dark
        actionButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }

        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }

    @objc private func actionButtonTapped(){
        delegate?.didTapSaveButton(self)
    }


    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        actionButton.layer.cornerRadius = actionButton.frame.size.height / 2
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        actionButton.layer.cornerRadius = actionButton.frame.size.height / 2
    }

    func config(with data: Any) {
        guard let data = data as? SavePlantButtonTableViewCellModel else { return }
        contentView.backgroundColor = .light
        actionButton.titleLabel?.font = .body()
        actionButton.setTitle(data.buttonTitle, for: .normal)
    }
}
