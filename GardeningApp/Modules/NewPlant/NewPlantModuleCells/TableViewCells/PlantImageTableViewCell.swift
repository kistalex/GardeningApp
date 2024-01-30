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
        contentView.backgroundColor = Constants.contentViewColor
        plantImageView.image = data.placeholderImage
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private enum Constants {
        static let verticalInsets: CGFloat = 10
        static let imageViewWidthConstraint: CGFloat = 150
        static let contentViewColor: UIColor = .light
        static let cornerRadiusDivider: CGFloat = 15
        static let borderColor: CGColor = UIColor.dark.cgColor
        static let borderWidth: CGFloat = 1
    }

    private let plantImageView:  UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setupImageViewLayout()
    }

    private func setupImageViewLayout(){
        plantImageView.layer.cornerRadius = plantImageView.frame.size.height / Constants.cornerRadiusDivider
        plantImageView.layer.borderWidth = Constants.borderWidth
        plantImageView.layer.borderColor = Constants.borderColor
    }

    private func setupViews() {
        contentView.addSubview(plantImageView)
        plantImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constants.verticalInsets)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.imageViewWidthConstraint)
            make.height.equalTo(plantImageView.snp.width)
        }
    }

    private func setupGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        plantImageView.isUserInteractionEnabled = true
        plantImageView.addGestureRecognizer(tap)
    }

    //MARK: - Selectors
    @objc private func openImagePicker() {
        delegate?.didTapOpenImagePicker(self)
    }
}
