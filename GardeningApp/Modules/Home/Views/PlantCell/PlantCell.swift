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
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .accent
        iv.layer.masksToBounds = true
        return iv
    }()

    private let nameLabel = CustomLabel(fontName: UIFont.body())
    private let ageLabel = CustomLabel(fontName: UIFont.body())

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
        plantImageView.layer.cornerRadius = 10
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

        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.accent.cgColor

        contentView.addSubview(plantImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ageLabel)


        plantImageView.layer.borderWidth = 1
        plantImageView.layer.borderColor = UIColor.accent.cgColor


        plantImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
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

    public func configureCell(with plant: Plant){
        plantImageView.image = UIImage(named: plant.image ?? "noImage")
        nameLabel.text = plant.name
        ageLabel.text = plant.age
    }
}
