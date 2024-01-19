//
//
// GardeningApp
// DatePlantCaringCell.swift
// 
// Created by Alexander Kist on 21.01.2024.
//


import UIKit
import SnapKit

class DatePlantCaringTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: DatePlantCaringTableViewCellModel.self)

    var labelText: String

    init(labelText: String) {
        self.labelText = labelText
    }
}


final class DatePlantCaringTableViewCell: UITableViewCell, AddPlantTableViewCellItem {

    weak var delegate: AddPlantTableViewItemDelegate?
    private let label = CustomLabel(fontName: .body(), textColor: .dark,textAlignment: .natural)
    private let datePicker = UIDatePicker()



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {
        contentView.addSubview(datePicker)
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(contentView.snp.centerX)
        }

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.tintColor = .dark

        datePicker.snp.makeConstraints { make in
            make.centerY.equalTo(label.snp.centerY) 
            make.trailing.equalToSuperview().inset(10)
        }
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        delegate?.didChoseStartCaringDate(self, with: sender.date)
    }

    func config(with data: Any) {
        guard let data = data as? DatePlantCaringTableViewCellModel else { return }
        contentView.backgroundColor = .light
        label.textColor = .dark
        label.text = data.labelText
    }
}



