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

    func config(with data: Any) {
        guard let data = data as? DatePlantCaringTableViewCellModel else { return }
        contentView.backgroundColor = Constants.contentViewColor
        label.text = data.labelText
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private enum Constants {
        static let topInset: CGFloat = 10
        static let horizontalInset: CGFloat = 10
        static let fontName: UIFont = .body()
        static let contentViewColor: UIColor = .light
        static let textColor: UIColor = .dark
        static let tintColor: UIColor = .dark
    }

    private let label = CustomLabel(fontName: Constants.fontName, textColor: Constants.textColor, textAlignment: .natural)

    private let datePicker = UIDatePicker()

    private func setupViews() {
        contentView.addSubview(datePicker)
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constants.topInset)
            make.leading.equalToSuperview().inset(Constants.horizontalInset)
            make.trailing.equalTo(contentView.snp.centerX)
        }

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.tintColor = Constants.tintColor

        datePicker.snp.makeConstraints { make in
            make.centerY.equalTo(label.snp.centerY) 
            make.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        delegate?.didChoseStartCaringDate(self, with: sender.date)
    }


}



