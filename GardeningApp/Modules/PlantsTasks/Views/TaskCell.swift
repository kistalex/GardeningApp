//
//
// GardeningApp
// TaskCell.swift
//
// Created by Alexander Kist on 02.01.2024.
//


import UIKit

class TaskCell: UICollectionViewCell {

    private let taskNameLabel = CustomLabel(fontName: .title(),text: "Some text" , textColor: .accentLight)
    private var statusButton = CustomImageButton(imageName: "circlebadge", configImagePointSize: 45, tintColor: .accentLight)
    private let deadLineLabel = CustomLabel(fontName: .body(),text: "Some text" , textColor: .accentLight, textAlignment: .natural)
    private let descriptionLabel = CustomLabel(fontName: .body(),text: "Some text Some text text Some text text Some text text Some text text Some text text Some text Some text text Some text text Some text text Some- " , textColor: .accentLight, textAlignment: .natural)


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    private func setupViews(){

        [taskNameLabel,statusButton, descriptionLabel, deadLineLabel].forEach { item in
            contentView.addSubview(item)
        }

        contentView.backgroundColor = .accentDark
        
        contentView.layer.cornerRadius = contentView.frame.size.height / 8
        contentView.layer.borderColor = UIColor.accentLight.cgColor
        contentView.layer.borderWidth = 2

        taskNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.leading.equalToSuperview().inset(10)
        }

        statusButton.snp.makeConstraints { make in
            make.centerY.equalTo(taskNameLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(10)
        }

        deadLineLabel.snp.makeConstraints { make in
            make.top.equalTo(statusButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(deadLineLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
