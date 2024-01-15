//
//
// GardeningApp
// DatePickerCell.swift
// 
// Created by Alexander Kist on 11.01.2024.
//


import UIKit
import SwiftUI
import SnapKit

final class DatePickerCollectionTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: DatePickerCollectionTableViewCellModel.self)

    var labelText: String
    var buttonTitle: String
    var dates: [Date]

    init(dates: [Date], labelText: String, buttonTitle: String) {
        self.dates = dates
        self.labelText = labelText
        self.buttonTitle = buttonTitle
    }
}

final class DatePickerCollectionTableViewCell: UITableViewCell, PlantTaskTableViewCellItem {

    weak var delegate: PlantTaskTableViewItemDelegate?

    private let dateLabel = UILabel()
    private var datePickerCollectionView: UICollectionView!
    private var cellData: [Date] = []
//    private var cellData = [
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 8).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 9).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 10).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 11).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 12).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 13).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 14).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 15).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 16).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 17).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 18).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 19).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 20).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 21).date!,
//        DateComponents(calendar: .current, year: 2024, month: 1, day: 22).date!
//    ]
    private let todayButton = CustomTextButton(bgColor: .accentDark)
    private var selectedDate: Date?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        datePickerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        datePickerCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "\(CalendarCell.self)")
        datePickerCollectionView.backgroundColor = .clear
        datePickerCollectionView.showsHorizontalScrollIndicator = false
        datePickerCollectionView.delegate = self
        datePickerCollectionView.dataSource = self
        datePickerCollectionView.isPagingEnabled = true
        datePickerCollectionView.backgroundColor = .accentLight

        [dateLabel, datePickerCollectionView, todayButton].forEach { item in
            contentView.addSubview(item)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.centerX.equalToSuperview().inset(20)
        }

        todayButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.leading.equalTo(dateLabel.snp.trailing).offset(10)
            make.width.equalTo(80)
        }

        datePickerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(150)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    func config(with data: Any) {
        guard let data = data as? DatePickerCollectionTableViewCellModel else { return }
        contentView.backgroundColor = .accentDark
        dateLabel.text = data.labelText
        dateLabel.textColor = .accentLight
        cellData = data.dates
        todayButton.setTitle(data.buttonTitle, for: .normal)
        datePickerCollectionView.reloadData()
    }

    
}
    // MARK: UICollectionViewDataSource
extension DatePickerCollectionTableViewCell: UICollectionViewDataSource {
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

extension DatePickerCollectionTableViewCell: UICollectionViewDelegate {
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

extension DatePickerCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}


struct DatePickerCellContentViewPreview: PreviewProvider {
    struct DatePickerCellContent: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            DatePickerCollectionTableViewCell()
        }
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }

    static var previews: some View {
        let size = UIScreen.main.bounds
        DatePickerCellContent()
            .padding(5)
            .frame(width: size.width, height: size.height / 5)
    }
}
