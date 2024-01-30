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

    func config(with data: Any) {
        guard let data = data as? TaskTableViewCellModel else { return }
        let config = UIImage.SymbolConfiguration(pointSize: Constants.imagePointSize)
        task = data.task

        guard let isComplete = task?.isComplete else {return}
        if isComplete {
            containerView.alpha = Constants.completeButtonAlpha
            completeButton.setImage(UIImage(systemName: Constants.completeButtonImageName, withConfiguration: config), for: .normal)
        } else {
            completeButton.setImage(UIImage(systemName: Constants.incompleteButtonImageName, withConfiguration: config), for: .normal)
            containerView.alpha = Constants.incompleteButtonAlpha
        }

        containerView.backgroundColor = .light
        nameLabel.text = "Plant Name: " + (task?.plantName ?? "")
        typeLabel.text = task?.taskType
        contentView.backgroundColor = .light
        deadLineLabel.text = "Date: \(task?.dueDate ?? "")"
        guard let description = task?.taskDescription else {return}
        descriptionLabel.text = "Description: \(description)"
    }

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

    private enum Constants {
        static let textFont = UIFont.body()
        static let titleFont = UIFont.title()
        static let textColor: UIColor = .dark
        static let contentViewEdgeInsets: CGFloat = 10
        static let verticalStackSpacing: CGFloat = 10
        static let stackHorizontalInsets: CGFloat = 10
        static let horizontalStackTopInset: CGFloat = 10
        static let verticalStackTopInset: CGFloat = 10
        static let verticalStackBottomInset: CGFloat = 10
        static let containerViewCornerDivider: CGFloat = 12
        static let containerBorderWidth: CGFloat = 2
        static let containerBorderColor = UIColor.dark.cgColor
        static let imagePointSize: CGFloat = 45
        static let incompleteButtonImageName = "circlebadge"
        static let completeButtonImageName = "circlebadge.fill"
        static let incompleteButtonAlpha: CGFloat = 1
        static let completeButtonAlpha: CGFloat = 0.5
    }

    private let nameLabel = CustomLabel(fontName: Constants.textFont, textColor: Constants.textColor)
    private let typeLabel = CustomLabel(fontName: Constants.titleFont, textColor: Constants.textColor)
    private var completeButton = CustomImageButton(imageName: Constants.incompleteButtonImageName, configImagePointSize: Constants.imagePointSize, tintColor: Constants.textColor)
    private let deadLineLabel = CustomLabel(fontName: Constants.textFont, textColor: Constants.textColor, textAlignment: .natural)
    private let descriptionLabel = CustomLabel(fontName: Constants.textFont, textColor: Constants.textColor, textAlignment: .natural)
    private let containerView = UIView()
    
    private var task: TaskViewModel?

    private func setupViews() {
        let horizontalStackView = UIStackView(arrangedSubviews: [typeLabel, completeButton])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing

        let verticalStackView = UIStackView(arrangedSubviews: [nameLabel, deadLineLabel, descriptionLabel])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .leading
        verticalStackView.spacing = Constants.verticalStackSpacing

        contentView.addSubview(containerView)
        containerView.addSubview(horizontalStackView)
        containerView.addSubview(verticalStackView)


        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.contentViewEdgeInsets)
        }

        horizontalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.horizontalStackTopInset)
            make.horizontalEdges.equalToSuperview().inset(Constants.stackHorizontalInsets)
        }
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(Constants.verticalStackTopInset)
            make.horizontalEdges.equalToSuperview().inset(Constants.stackHorizontalInsets)
            make.bottom.lessThanOrEqualToSuperview().inset(Constants.verticalStackBottomInset)
        }

        completeButton.addTarget(self, action: #selector(completeTask), for: .touchUpInside)
    }
    
    @objc private func completeTask(){
        delegate?.completeButtonDidTap(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = containerView.frame.size.height / Constants.containerViewCornerDivider
        containerView.layer.borderColor = Constants.containerBorderColor
        containerView.layer.borderWidth = Constants.containerBorderWidth
    }
}
