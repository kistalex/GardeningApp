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
    private var recommendationLabel = CustomLabel(fontName: .body(), textColor: .dark, textAlignment: .natural)
    private let textView = PlaceholderTextView()
    private var lastReturnKeyPress: Date?


    private var inputText = ""


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTextView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextView()
    }

    private func setupTextView() {
        textView.delegate = self
        contentView.addSubview(textView)
        contentView.addSubview(recommendationLabel)

        recommendationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(recommendationLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.greaterThanOrEqualTo(150)
        }
    }


    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        textView.layer.cornerRadius = textView.frame.size.height / 12
        textView.layer.borderColor = UIColor.dark.cgColor
        textView.layer.borderWidth = 1
        textView.backgroundColor = .light
        textView.textColor = .dark
    }

    func config(with data: Any) {
        guard let data = data as? PlantDescriptionTableViewCellModel else { return }
        contentView.backgroundColor = .light

        textView.placeholder = data.placeholderText
        recommendationLabel.text = data.labelText
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

