//
//
// GardeningApp
// TaskCell.swift
//
// Created by Alexander Kist on 02.01.2024.
//


import UIKit

class TaskCell: UICollectionViewCell {

    private let nameLabel = CustomLabel(fontName: .body(), textColor: .accentLight)
    private let typeLabel = CustomLabel(fontName: .title(), textColor: .accentLight)
    private var statusButton = CustomImageButton(imageName: "circlebadge", configImagePointSize: 45, tintColor: .accentLight)
    private let deadLineLabel = CustomLabel(fontName: .body(), textColor: .accentLight, textAlignment: .natural)
    private let descriptionLabel = CustomLabel(fontName: .body(), textColor: .accentLight, textAlignment: .natural)


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    private func setupViews(){

        [nameLabel, typeLabel, statusButton, descriptionLabel, deadLineLabel].forEach { item in
            contentView.addSubview(item)
        }

        contentView.backgroundColor = .accentDark
        
        contentView.layer.cornerRadius = contentView.frame.size.height / 8
        contentView.layer.borderColor = UIColor.accentLight.cgColor
        contentView.layer.borderWidth = 2

        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.leading.equalToSuperview().inset(10)
        }

        statusButton.snp.makeConstraints { make in
            make.centerY.equalTo(typeLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(10)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(statusButton.snp.bottom).offset(10)
            make.leading.equalTo(typeLabel)
        }


        deadLineLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(deadLineLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }

    func configure(with model: TaskModel){

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dueDateString = dateFormatter.string(from: model.dueDate ?? Date())
        
        nameLabel.text = "Plant Name: " + (model.plantName ?? "")
        typeLabel.text = model.taskType
        deadLineLabel.text = "Date: \(dueDateString)"
        descriptionLabel.text = model.taskDescription
    }
}
