//
//
// GardeningApp
// PlantTypeCollectionCell.swift
// 
// Created by Alexander Kist on 21.01.2024.
//


import UIKit

final class PlantTypeCollectionCell: UICollectionViewCell {

    private enum Constants {
        static let textFont = UIFont.body()
        static let textColor: UIColor = .dark
        static let selectedColor: UIColor = .dark
        static let unselectedColor: UIColor = .light
        static let labelEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        static let cornerRadiusDivider: CGFloat = 2
        static let borderWidth: CGFloat = 1
        static let borderColor: CGColor = UIColor.dark.cgColor
    }

    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Constants.textFont
        label.textColor = Constants.textColor
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
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.labelEdgeInsets)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
        layer.cornerRadius = 0
        layer.borderWidth = 0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / Constants.cornerRadiusDivider
        layer.masksToBounds = true
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = Constants.borderColor
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = self.isSelected ? Constants.selectedColor : Constants.unselectedColor
            textLabel.textColor = self.isSelected ? Constants.unselectedColor : Constants.selectedColor
        }
    }

    func configure(with name: String) {
        textLabel.text = name
    }
}
