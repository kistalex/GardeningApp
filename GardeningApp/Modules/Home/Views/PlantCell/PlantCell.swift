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
        iv.tintColor = .accentLight
        iv.layer.masksToBounds = true
        return iv
    }()

    private let nameLabel = CustomLabel(fontName: UIFont.body(), textColor: .accentDark)
    private let ageLabel = CustomLabel(fontName: UIFont.body(), textColor: .accentDark)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
        plantImageView.layer.cornerRadius = 10
        plantImageView.layer.borderColor = UIColor.accentDark.cgColor
        plantImageView.layer.borderWidth = 1
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        plantImageView.image = nil
        nameLabel.text = nil
        ageLabel.text = nil
    }

    private func setupViews(){
        contentView.backgroundColor = .accentLight
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

    public func configureCell(with plant: PlantObject){
        plantImageView.image = plant.image
        nameLabel.text = plant.plantName
        ageLabel.text = plant.plantAge
    }
}
