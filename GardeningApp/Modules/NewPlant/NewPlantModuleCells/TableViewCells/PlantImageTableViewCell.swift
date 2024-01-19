//
//
// GardeningApp
// PlantImageTableViewCell.swift
//
// Created by Alexander Kist on 21.01.2024.
//


import UIKit

class PlantImageTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: PlantImageTableViewCellModel.self)

    var placeholderImage: UIImage


    init(placeholderImage: UIImage) {
        self.placeholderImage = placeholderImage
    }
}


final class PlantImageTableViewCell: UITableViewCell, AddPlantTableViewCellItem {

    weak var delegate: AddPlantTableViewItemDelegate?

    func config(with data: Any) {
        guard let data = data as? PlantImageTableViewCellModel else { return }
        contentView.backgroundColor = .light
        plantImageView.image = data.placeholderImage
    }

    private let plantImageView:  UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {
        contentView.addSubview(plantImageView)

        plantImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.centerX.equalToSuperview().inset(10)
            make.width.equalTo(150)
            make.height.equalTo(plantImageView.snp.width)
        }
    }

    private func setupGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        plantImageView.isUserInteractionEnabled = true
        plantImageView.addGestureRecognizer(tap)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        plantImageView.layer.cornerRadius = plantImageView.frame.size.height / 15
        plantImageView.layer.borderWidth = 1
        plantImageView.layer.borderColor = UIColor.dark.cgColor
    }

    //MARK: - Selectors

    @objc private func openImagePicker() {
        delegate?.didTapOpenImagePicker(self)
    }
}
