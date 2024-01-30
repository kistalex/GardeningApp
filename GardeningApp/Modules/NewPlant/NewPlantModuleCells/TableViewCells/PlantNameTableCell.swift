//
//
// GardeningApp
// PlantNameTableCell.swift
// 
// Created by Alexander Kist on 21.01.2024.
//


import UIKit
import SnapKit

class PlantNameTableCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: PlantNameTableCellModel.self)
}

class PlantNameTableCell: UITableViewCell, AddPlantTableViewCellItem  {

    weak var delegate: AddPlantTableViewItemDelegate?

    func config(with data: Any) {
        contentView.backgroundColor = Constants.contentViewColor
        nameTField.delegate = self
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private enum Constants {
        static let verticalInsets: CGFloat = 10
        static let horizontalInset: CGFloat = 10
        static let tFieldHeightConstraint: CGFloat = 50
        static let contentViewColor: UIColor = .light
    }
    
    private let nameTField = CustomTextField(tFieldType: .name)

    private func setupView(){
        contentView.addSubview(nameTField)

        nameTField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constants.verticalInsets)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.height.equalTo(Constants.tFieldHeightConstraint)
        }
    }
}

extension PlantNameTableCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.didInputPlantName(self, with: text)
        }
    }
}


