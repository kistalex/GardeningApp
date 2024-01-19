//
//
// GardeningApp
// CustomTextView.swift
//
// Created by Alexander Kist on 12.12.2023.
//


import UIKit

final class CustomTextView: UITextView, UITextViewDelegate {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: .zero, textContainer: textContainer)
        backgroundColor = .light
        layer.borderWidth = 1
        font = UIFont.body()
        autocorrectionType = .no
        delegate = self
        textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.borderColor = UIColor.dark.cgColor
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
