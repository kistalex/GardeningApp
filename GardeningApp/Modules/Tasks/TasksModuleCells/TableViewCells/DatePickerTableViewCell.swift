//
//
// GardeningApp
// DatePickerCell.swift
//
// Created by Alexander Kist on 11.01.2024.
//


import UIKit
import SnapKit

class DatePickerTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: DatePickerTableViewCellModel.self)

    var dates: [Date]
    var selectedDate: Date

    init(dates: [Date], selectedDate: Date) {
        self.dates = dates
        self.selectedDate = selectedDate
    }
}

class DatePickerTableViewCell: UITableViewCell, TaskTableViewCellItem {

    weak var delegate: TaskTableViewItemDelegate?

    func config(with data: Any) {
        guard let data = data as? DatePickerTableViewCellModel else { return }
        contentView.backgroundColor = Constants.contentViewBgColor
        selectedDate = data.selectedDate
        cellData = data.dates
        datePickerCollectionView.reloadData()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    private enum Constants {
        static let sectionTopInset: CGFloat = 10
        static let sectionBottomInset: CGFloat = 10
        static let sectionLeftInset: CGFloat = 0
        static let sectionRightInset: CGFloat = 0
        static let verticalInsets: CGFloat = 10
        static let horizontalInsets: CGFloat = 10
        static let collectionHeightConstraint: CGFloat = 150
        static let itemWidthDivider: CGFloat = 1.5
        static let cornerRadiusDivider: CGFloat = 12
        static let borderWidth: CGFloat = 1
        static let borderColor: CGColor = UIColor.dark.cgColor
        static let contentViewBgColor: UIColor = .light
    }

    private var datePickerCollectionView: UICollectionView!
    private var cellData: [Date] = []
    private var selectedDate: Date?


    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        datePickerCollectionView.layer.cornerRadius = datePickerCollectionView.frame.size.height / Constants.cornerRadiusDivider
        datePickerCollectionView.layer.borderWidth = Constants.borderWidth
        datePickerCollectionView.layer.borderColor = Constants.borderColor
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(
            top: Constants.sectionTopInset,
            left: Constants.sectionLeftInset,
            bottom: Constants.sectionBottomInset,
            right: Constants.sectionRightInset
        )

        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        datePickerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        datePickerCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "\(CalendarCell.self)")
        datePickerCollectionView.backgroundColor = .clear
        datePickerCollectionView.showsHorizontalScrollIndicator = false
        datePickerCollectionView.delegate = self
        datePickerCollectionView.dataSource = self
        datePickerCollectionView.isPagingEnabled = true
        datePickerCollectionView.backgroundColor = .dark

        contentView.addSubview(datePickerCollectionView)

        datePickerCollectionView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(Constants.verticalInsets)
            make.horizontalEdges.equalTo(contentView).inset(Constants.horizontalInsets)
            make.height.equalTo(Constants.collectionHeightConstraint)
        }
    }

    //MARK: - Selectors
    @objc private func todayButtonTapped(){
        delegate?.didSelectDate(self, with: selectedDate)
    }
}
extension DatePickerTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CalendarCell.self)", for: indexPath) as? CalendarCell else {
            return UICollectionViewCell()
        }

        let date = cellData[indexPath.item]
        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate ?? Date())
        cell.configure(with: date, isSelected: isSelected)
        return cell
    }
}

extension DatePickerTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = cellData[indexPath.item]
        delegate?.didSelectDate(self, with: selectedDate)
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension DatePickerTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        let leftInset = flowLayout.sectionInset.left
        let rightInset = flowLayout.sectionInset.right
        let totalInset = leftInset + rightInset

        let availableWidth = collectionView.bounds.width - totalInset
        let widthPerItem = availableWidth / 7
        let height = collectionView.bounds.height - (flowLayout.sectionInset.top + flowLayout.sectionInset.bottom)

        return CGSize(width: widthPerItem, height: height)
    }
}

