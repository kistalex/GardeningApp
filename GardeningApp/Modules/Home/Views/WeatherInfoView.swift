//
//
// GardeningApp
// WeatherInfoView.swift
// 
// Created by Alexander Kist on 11.12.2023.
//


import UIKit

class WeatherInfoView: UIView {

    private let stackView = UIStackView()
    private let imageView = UIImageView()
    let label = UILabel()

    init(imageName: String) {
        super.init(frame: .zero)
        imageView.image = UIImage(systemName: imageName)
        imageView.tintColor = .tint
        label.textColor = .tint
        label.text = "-/-"
        label.font = UIFont.body()
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalCentering
        imageView.contentMode = .scaleAspectFit
        label.numberOfLines = 0

        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
