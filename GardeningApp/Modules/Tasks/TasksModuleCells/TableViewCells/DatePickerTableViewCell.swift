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
    typealias DateTuple = (dayOfWeek: String, dayOfMonth: String)

    private var datePickerCollectionView: UICollectionView!
    private var cellData: [Date] = []
    private var cellStringData: [DateTuple] = []
    private var selectedDate: Date?
    private var selectedStringDate: DateTuple?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        datePickerCollectionView.layer.cornerRadius = datePickerCollectionView.frame.size.height / 12
        datePickerCollectionView.layer.borderWidth = 1
        datePickerCollectionView.layer.borderColor = UIColor.dark.cgColor
    }

    func config(with data: Any) {
        guard let data = data as? DatePickerTableViewCellModel else { return }
        contentView.backgroundColor = .light
        selectedDate = data.selectedDate
        cellData = data.dates
        datePickerCollectionView.reloadData()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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
            make.verticalEdges.equalTo(contentView).inset(10)
            make.horizontalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(150)
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

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let layout = self.datePickerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
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

