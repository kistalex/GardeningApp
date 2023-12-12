//
//
// GardeningApp
// ShadowImageView.swift
// 
// Created by Alexander Kist on 12.12.2023.
//


import UIKit

class ShadowImageView: UIView {

    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.accent.withAlphaComponent(0.5).cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 10.0
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 10.0
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

}
