//
//
// GardeningApp
// PlantTypeCollectionCell.swift
// 
// Created by Alexander Kist on 21.01.2024.
//


import UIKit

final class PlantTypeCollectionCell: UICollectionViewCell {

    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .body()
        label.textColor = .dark
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
        textLabel.font = .body()
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
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
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.dark.cgColor
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = self.isSelected ? .dark : .light
            textLabel.textColor = self.isSelected ? .light : .dark
        }
    }

    func configure(with name: String) {
        textLabel.text = name
    }
}
