//
//
// GardeningApp
// CalendarCell.swift
// 
// Created by Alexander Kist on 28.12.2023.
//


import Foundation
import SnapKit
import UIKit

class CalendarCell: UICollectionViewCell {

    private enum Constants {
        static let textFont = UIFont.body()
        static let accentColor: UIColor = .dark
        static let contentViewAccentColor: UIColor = .light
        static let contentViewUnselectedColor: UIColor = .clear
        static let unselectedColor: UIColor = .light
        static let stackSpacing: CGFloat = 10
        static let stackEdgeInset: CGFloat = 5
        static let dayNameFormat = "EEE"
        static let dayDateFormat = "dd"
        static let contentViewDivider: CGFloat = 5
    }

    private let dayLabel = CustomLabel(fontName: Constants.textFont, textColor: Constants.accentColor)
    private let dateLabel = CustomLabel(fontName: Constants.textFont, textColor: Constants.accentColor)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [dayLabel, dateLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.stackSpacing

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.stackEdgeInset)
        }
    }

    override func prepareForReuse() {
        dayLabel.text = nil
        dateLabel.text = nil
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = .zero
    }

    func configure(with date: Date, isSelected: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dayNameFormat
        dayLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = Constants.dayDateFormat
        dateLabel.text = dateFormatter.string(from: date)

        if isSelected {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4) {
                    self.contentView.backgroundColor = Constants.contentViewAccentColor
                    self.dayLabel.textColor = Constants.accentColor
                    self.dateLabel.textColor = Constants.accentColor
                }
            }
        } else {
            contentView.backgroundColor = Constants.contentViewUnselectedColor
            dayLabel.textColor = Constants.unselectedColor
            dateLabel.textColor = Constants.unselectedColor
        }
        
        contentView.layer.cornerRadius = isSelected ? contentView.frame.size.height / Constants.contentViewDivider : 0
    }
}
