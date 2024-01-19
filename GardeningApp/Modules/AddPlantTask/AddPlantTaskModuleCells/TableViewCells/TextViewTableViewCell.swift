//
//
// GardeningApp
// TextViewTableViewCell.swift
// 
// Created by Alexander Kist on 09.01.2024.
//


import UIKit

final class TextViewTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: TextViewTableViewCellModel.self)

    var placeholderText: String

    init(placeholderText: String) {
        self.placeholderText = placeholderText
    }
}

final class TextViewTableViewCell: UITableViewCell, AddTaskTableViewCellItem {

    weak var delegate: AddTaskTableViewItemDelegate?

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
        textView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
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
        guard let data = data as? TextViewTableViewCellModel else { return }
        contentView.backgroundColor = .light

        textView.placeholder = data.placeholderText
    }
}

extension TextViewTableViewCell: UITextViewDelegate  {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didWriteDescription(self, withText: textView.text)
    }
}
