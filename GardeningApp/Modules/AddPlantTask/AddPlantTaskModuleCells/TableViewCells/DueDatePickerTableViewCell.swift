//
//
// GardeningApp
// DueDatePickerTableViewCell.swift
// 
// Created by Alexander Kist on 09.01.2024.
//


import UIKit

final class DueDatePickerTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: DueDatePickerTableViewCellModel.self)

    var labelText: String

    init(labelText: String) {
        self.labelText = labelText
    }
}


final class DueDatePickerTableViewCell: UITableViewCell, AddTaskTableViewCellItem {

    weak var delegate: AddTaskTableViewItemDelegate?
    private let label = CustomLabel(fontName: .body(), textColor: .dark, textAlignment: .left)
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
        delegate?.didSelectDate(self, withDate: sender.date)
    }

    func config(with data: Any) {
        guard let data = data as? DueDatePickerTableViewCellModel else { return }
        contentView.backgroundColor = .light
        label.text = data.labelText
    }
}

