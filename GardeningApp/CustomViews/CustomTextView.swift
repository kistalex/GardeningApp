//
//
// GardeningApp
// CustomTextView.swift
//
// Created by Alexander Kist on 09.01.2024.
//


import UIKit

final class CustomTextView: UITextView {

    // MARK: - Properties
    var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
        }
    }

    private let placeholderLabel: UILabel = UILabel()

    // MARK: - Initializers
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)

        placeholderLabel.font = self.font
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = .clear
        addSubview(placeholderLabel)
        font = .body()
        textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        placeholderLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        placeholderLabel.isHidden = self.text.count > 0
    }

    @objc private func textDidChange() {
        placeholderLabel.isHidden = self.text.count > 0
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK:  Overrides
    override var text: String! {
        didSet {
            textDidChange()
        }
    }

    override var font: UIFont? {
        didSet {
            placeholderLabel.font = self.font
        }
    }

    override var contentInset: UIEdgeInsets {
        didSet {
            setNeedsLayout()
        }
    }

    override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = self.frame.width - self.textContainerInset.left - self.textContainerInset.right
    }
}
