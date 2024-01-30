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


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private enum Constants {
        static let labelVerticalInsets: CGFloat = 10
        static let labelLeadingInset: CGFloat = 10
        static let datePickerTrailingInset: CGFloat = 10
        static let fontName: UIFont = .body()
        static let contentViewColor: UIColor = .light
        static let textColor: UIColor = .dark
        static let tintColor: UIColor = .dark
    }

    private let label = CustomLabel(fontName: Constants.fontName, textColor: Constants.textColor, textAlignment: .left)
    private let datePicker = UIDatePicker()

    private func setupViews() {
        contentView.addSubview(datePicker)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constants.labelVerticalInsets)
            make.leading.equalToSuperview().inset(Constants.labelLeadingInset)
            make.trailing.equalTo(contentView.snp.centerX)
        }
        datePicker.tintColor = Constants.tintColor
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .automatic

        datePicker.snp.makeConstraints { make in
            make.centerY.equalTo(label.snp.centerY)
            make.trailing.equalToSuperview().inset(Constants.datePickerTrailingInset)
        }
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        delegate?.didSelectDate(self, withDate: sender.date)
    }

    func config(with data: Any) {
        guard let data = data as? DueDatePickerTableViewCellModel else { return }
        contentView.backgroundColor = Constants.contentViewColor
        label.text = data.labelText
    }
}

