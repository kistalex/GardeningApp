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

    private let textView = CustomTextView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTextView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextView()
    }

    private enum Constants {
        static let textViewEdgesInsets: CGFloat = 10
        static let textViewMinimumTextViewHeight: CGFloat = 150
        static let textViewCornerRadiusDivider: CGFloat = 12
        static let textViewBorderWidth: CGFloat = 1
        static let textViewBorderColor: CGColor = UIColor.dark.cgColor
        static let contentViewColor: UIColor = .light
        static let textViewColor: UIColor = .light
        static let textColor: UIColor = .dark
    }

    private func setupTextView() {
        textView.delegate = self
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.textViewEdgesInsets)
            make.height.greaterThanOrEqualTo(Constants.textViewMinimumTextViewHeight)
        }
    }


    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        textView.layer.cornerRadius = textView.frame.size.height / Constants.textViewCornerRadiusDivider
        textView.layer.borderColor = Constants.textViewBorderColor
        textView.layer.borderWidth = Constants.textViewBorderWidth
        textView.backgroundColor = Constants.textViewColor
        textView.textColor = Constants.textColor
    }

    func config(with data: Any) {
        guard let data = data as? TextViewTableViewCellModel else { return }
        contentView.backgroundColor = Constants.contentViewColor
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
