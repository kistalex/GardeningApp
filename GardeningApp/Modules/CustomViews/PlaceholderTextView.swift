//
//
// GardeningApp
// PlaceholderTextView.swift
//
// Created by Alexander Kist on 09.01.2024.
//


import UIKit

final class PlaceholderTextView: UITextView {

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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)

        placeholderLabel.font = self.font
        placeholderLabel.textColor = .accentLight.withAlphaComponent(0.5) 
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = .clear
        addSubview(placeholderLabel)
        font = .body()
        // Layout

        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(5)
        }

        placeholderLabel.isHidden = self.text.count > 0
    }

    // MARK: - Placeholder Visibility
    @objc private func textDidChange() {
        placeholderLabel.isHidden = self.text.count > 0
    }

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Overrides
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
