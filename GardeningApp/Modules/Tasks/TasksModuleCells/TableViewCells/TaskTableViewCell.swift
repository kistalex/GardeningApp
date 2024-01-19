//
//
// GardeningApp
// TaskTableViewCell.swift
// 
// Created by Alexander Kist on 16.01.2024.
//


import Foundation
import UIKit

final class TaskTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: TaskTableViewCellModel.self)

    var task: TaskViewModel

    init(task: TaskViewModel) {
        self.task = task
    }
}


class TaskTableViewCell: UITableViewCell, TaskTableViewCellItem {
   
    weak var delegate: TaskTableViewItemDelegate?

    private var task: TaskViewModel?

    private let nameLabel = CustomLabel(fontName: .body(), textColor: .dark)
    private let typeLabel = CustomLabel(fontName: .title(), textColor: .dark)
    private var completeButton = CustomImageButton(imageName: "circlebadge", configImagePointSize: 45, tintColor: .dark)
    private let deadLineLabel = CustomLabel(fontName: .body(), textColor: .dark, textAlignment: .natural)
    private let descriptionLabel = CustomLabel(fontName: .body(), textColor: .dark, textAlignment: .natural)
    private let containerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        typeLabel.text = nil
        deadLineLabel.text = nil
        descriptionLabel.text = nil
    }

    private func setupViews() {
        let horizontalStackView = UIStackView(arrangedSubviews: [typeLabel, completeButton])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing

        let verticalStackView = UIStackView(arrangedSubviews: [nameLabel, deadLineLabel, descriptionLabel])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .leading
        verticalStackView.spacing = 10

        contentView.addSubview(containerView)
        containerView.addSubview(horizontalStackView)
        containerView.addSubview(verticalStackView)


        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        horizontalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualToSuperview().inset(10)
        }

        completeButton.addTarget(self, action: #selector(completeTask), for: .touchUpInside)
    }
    
    @objc private func completeTask(){
        delegate?.completeButtonDidTap(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = containerView.frame.size.height / 12
        containerView.layer.borderColor = UIColor.dark.cgColor
        containerView.layer.borderWidth = 2
    }

    func config(with data: Any) {
        guard let data = data as? TaskTableViewCellModel else { return }
        let config = UIImage.SymbolConfiguration(pointSize: 45)
        task = data.task
        
        guard let isComplete = task?.isComplete else {return}
        if isComplete {
            containerView.alpha = 0.5
            completeButton.setImage(UIImage(systemName: "circlebadge.fill", withConfiguration: config), for: .normal)
        } else {
            completeButton.setImage(UIImage(systemName: "circlebadge", withConfiguration: config), for: .normal)
            containerView.alpha = 1
        }

        containerView.backgroundColor = .light
        nameLabel.text = "Plant Name: " + (task?.plantName ?? "")
        typeLabel.text = task?.taskType
        contentView.backgroundColor = .light
        deadLineLabel.text = "Date: \(task?.dueDate ?? "")"
        guard let description = task?.taskDescription else {return}
        descriptionLabel.text = "Description: \(description)"
    }
}
