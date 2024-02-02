//
//
// GardeningApp
// PlantDescriptionTableViewCell.swift
// 
// Created by Alexander Kist on 21.01.2024.
//


import UIKit
import SnapKit

class PlantDescriptionTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: PlantDescriptionTableViewCellModel.self)

    var placeholderText: String
    var labelText: String

    init(placeholderText: String, labelText: String) {
        self.placeholderText = placeholderText
        self.labelText = labelText
    }
}

final class PlantDescriptionTableViewCell: UITableViewCell, AddPlantTableViewCellItem {


    weak var delegate: AddPlantTableViewItemDelegate?

    func config(with data: Any) {
        guard let data = data as? PlantDescriptionTableViewCellModel else { return }
        contentView.backgroundColor = Constants.contentViewColor

        textView.placeholder = data.placeholderText
        recommendationLabel.text = data.labelText
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTextView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextView()
    }

    private enum Constants {
        static let topInset: CGFloat = 10
        static let horizontalInset: CGFloat = 10
        static let textViewBottomInset: CGFloat = 10
        static let minimumTextViewHeight: CGFloat = 150
        static let cornerRadiusDivider: CGFloat = 12
        static let borderWidth: CGFloat = 1
        static let fontName: UIFont = .body()
        static let contentViewColor: UIColor = .light
        static let textColor: UIColor = .dark
    }

    private var recommendationLabel = CustomLabel(fontName: Constants.fontName, textColor: Constants.textColor, textAlignment: .natural)

    private let textView = CustomTextView()

    private func setupTextView() {
        textView.delegate = self
        contentView.addSubview(textView)
        contentView.addSubview(recommendationLabel)

        recommendationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.topInset)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(recommendationLabel.snp.bottom).offset(Constants.topInset)
            make.bottom.equalToSuperview().inset(Constants.textViewBottomInset)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.height.greaterThanOrEqualTo(Constants.minimumTextViewHeight)
        }
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        textView.layer.cornerRadius = textView.frame.size.height / Constants.cornerRadiusDivider
        textView.layer.borderColor = UIColor.dark.cgColor
        textView.layer.borderWidth = Constants.borderWidth
        textView.backgroundColor = Constants.contentViewColor
        textView.textColor = Constants.textColor
    }
}

extension PlantDescriptionTableViewCell: UITextViewDelegate  {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didWriteDescription(self, with: textView.text)
    }
}

//        static let contentViewBgColor: UIColor = .light
