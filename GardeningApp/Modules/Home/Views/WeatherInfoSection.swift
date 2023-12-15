//
//
// GardeningApp
// WeatherInfoSection.swift
// 
// Created by Alexander Kist on 11.12.2023.
//


import UIKit

final class WeatherInfoSection: UIView {

    private let stackView = UIStackView()
    private let imageView = UIImageView()
    let label = UILabel()

    init(imageName: String) {
        super.init(frame: .zero)
        imageView.image = UIImage(systemName: imageName)
        imageView.tintColor = .accentLight
        label.textColor = .accentLight
        label.text = "-/-"
        label.font = UIFont.body()
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {
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
