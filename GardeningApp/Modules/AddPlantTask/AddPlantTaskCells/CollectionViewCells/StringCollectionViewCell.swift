//
//
// GardeningApp
// StringCollectionViewCell.swift
// 
// Created by Alexander Kist on 10.01.2024.
//


import UIKit

final class StringCollectionViewCell: UICollectionViewCell {

    private let stringLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .body()
        label.textColor = .accentLight
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }

    private func setupLabel() {
        contentView.addSubview(stringLabel)
        stringLabel.font = .body()
        stringLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.accentLight.cgColor
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = self.isSelected ? .accentLight : .accentDark
            stringLabel.textColor = self.isSelected ? .accentDark : .accentLight
        }
    }

    func configure(with string: String) {
        stringLabel.text = string
    }
}
