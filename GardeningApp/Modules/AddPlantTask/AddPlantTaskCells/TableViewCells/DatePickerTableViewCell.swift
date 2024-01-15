//
//
// GardeningApp
// DatePickerTableViewCell.swift
// 
// Created by Alexander Kist on 09.01.2024.
//


import UIKit

class DatePickerTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: DatePickerTableViewCellModel.self)

    var labelText: String
    var dateChangeHandler: ((Date) -> Void)?

    init(labelText: String, dateChangeHandler: ((Date) -> Void)? = nil) {
        self.labelText = labelText
        self.dateChangeHandler = dateChangeHandler
    }
}

// MARK: - DatePickerCell View

final class DatePickerTableViewCell: UITableViewCell, AddPlantTableViewCellItem {

    weak var delegate: AddTaskTableViewItemDelegate?
    private let label = UILabel()
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
            make.centerY.equalTo(datePicker.snp.centerY)
            make.leading.equalToSuperview().inset(10)
        }

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.tintColor = .accentLight

        datePicker.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        delegate?.didSelectDate(self, withDate: sender.date)
    }

    func config(with data: Any) {
        guard let data = data as? DatePickerTableViewCellModel else { return }
        contentView.backgroundColor = .accentDark
        label.textColor = .accentLight
        label.text = data.labelText
    }
}

