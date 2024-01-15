//
//
// GardeningApp
// TaskTypesCollectionViewCell.swift
//
// Created by Alexander Kist on 05.01.2024.
//


import UIKit

class TaskTypesCollectionViewCell: UICollectionViewCell {

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.body()
        label.textColor = .accentLight
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.accentDark.cgColor
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = self.isSelected ? .accentLight : .accentDark
            categoryLabel.textColor = self.isSelected ? .accentDark : .accentLight
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }

    private func setupViews() {

        contentView.addSubview(categoryLabel)

        categoryLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    func configure(with text: String) {
        categoryLabel.text = text
    }

}
