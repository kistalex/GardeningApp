//
//
// GardeningApp
// PlantCell.swift
//
// Created by Alexander Kist on 12.12.2023.
//


import UIKit

class PlantCell: UICollectionViewCell {

    private enum Constants {
        static let imageViewCornerRadius: CGFloat = 10
        static let contentViewCornerRadius: CGFloat = 10
        static let textFont = UIFont.body()
        static let textColor: UIColor = .light
        static let contentViewBorderColor: CGColor = UIColor.dark.cgColor
        static let contentViewBorderWidth: CGFloat = 2
        static let stackSpacing: CGFloat = 10
        static let viewBgColor: UIColor = .dark.withAlphaComponent(0.8)
        static let stackEdgeInset: CGFloat = 5
    }

    private let plantImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()

    private let nameLabel = CustomLabel(fontName: Constants.textFont, textColor: Constants.textColor)
    private let ageLabel = CustomLabel(fontName: Constants.textFont, textColor: Constants.textColor)
    private var verticalStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutImageView()
        layoutContentView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func layoutImageView(){
        plantImageView.layer.cornerRadius = Constants.imageViewCornerRadius
    }

    private func layoutContentView(){
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.layer.borderColor = Constants.contentViewBorderColor
        contentView.layer.borderWidth = Constants.contentViewBorderWidth
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

        verticalStack.axis = .vertical
        verticalStack.distribution = .fill
        verticalStack.alignment = .leading
        verticalStack.spacing = Constants.stackSpacing

        [nameLabel, ageLabel].forEach { item in
            verticalStack.addArrangedSubview(item)
        }

        let bgTextView = UIView()
        bgTextView.backgroundColor = Constants.viewBgColor

        contentView.addSubview(plantImageView)
        plantImageView.addSubview(bgTextView)
        bgTextView.addSubview(verticalStack)

        plantImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        bgTextView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.stackEdgeInset)
        }
    }

    public func configureCell(with plant: PlantViewModel){
        plantImageView.image = plant.image
        nameLabel.text = plant.name
        ageLabel.text = plant.age
    }
}
