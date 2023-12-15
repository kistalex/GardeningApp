//
//
// GardeningApp
// ShadowImageView.swift
// 
// Created by Alexander Kist on 12.12.2023.
//


import UIKit

final class ShadowImageView: UIView {

    private lazy var shadowView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews(){
        addSubview(shadowView)
        shadowView.addSubview(iconImageView)

        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public func setImage(with image: UIImage?){
        iconImageView.image = image
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.layer.shadowColor = UIColor.accentLight.withAlphaComponent(0.5).cgColor
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 10.0
    }

}
