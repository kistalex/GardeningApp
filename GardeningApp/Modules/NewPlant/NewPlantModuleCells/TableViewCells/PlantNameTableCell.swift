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

    private let nameTField = CustomTextField(tFieldType: .name)

    func config(with data: Any) {
        contentView.backgroundColor = .light
        nameTField.delegate = self
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupView(){
        contentView.addSubview(nameTField)

        nameTField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(50)
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


