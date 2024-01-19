//
//
// GardeningApp
// PlantCell.swift
//
// Created by Alexander Kist on 12.12.2023.
//


import UIKit

class PlantCell: UICollectionViewCell {

    private let plantImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.tintColor = .dark
        iv.layer.masksToBounds = true
        return iv
    }()

    private let nameLabel = CustomLabel(fontName: UIFont.body(), textColor: .light)
    private let ageLabel = CustomLabel(fontName: UIFont.body(), textColor: .light)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
        plantImageView.layer.cornerRadius = 10
        plantImageView.layer.borderColor = UIColor.light.cgColor
        plantImageView.layer.borderWidth = 2
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        plantImageView.image = nil
        nameLabel.text = nil
        ageLabel.text = nil
        plantImageView.layer.borderWidth = 0
        plantImageView.layer.borderColor = UIColor.clear.cgColor
    }

    private func setupViews(){
        nameLabel.numberOfLines = 1
        contentView.backgroundColor = .dark
        contentView.addSubview(plantImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ageLabel)

        plantImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(1.5)
            make.width.equalTo(plantImageView.snp.height)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(plantImageView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(plantImageView)
        }

        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(plantImageView)
        }
    }

    public func configureCell(with plant: PlantViewModel){
        plantImageView.image = plant.image
        nameLabel.text = plant.name
        ageLabel.text = plant.age
    }
}
