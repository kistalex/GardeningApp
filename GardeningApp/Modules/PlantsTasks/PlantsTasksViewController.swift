//
// GardeningApp
// PlantsTasksViewController.swift
//
// Created by Alexander Kist on 22.12.2023.
//

import UIKit
import SwiftUI

protocol PlantsTasksViewProtocol: AnyObject {
    func setDates(dates: [Date])
    func setCurrentDate(date: Date)
    func setCurrentDateLabel(date: String)
    func refreshCollectionViewAndScrollToCurrentDate()
}

class PlantsTasksViewController: UIViewController {
    // MARK: - Public
    var presenter: PlantsTasksPresenterProtocol?

    private let dateLabel = CustomLabel(fontName: UIFont.body(), textColor: .accentLight)
    private let todayButton = CustomTextButton(text: "Today", bgColor: .accentDark)
    private lazy var datePickerCollectionView = UICollectionView()
    private let addTaskButton = CustomImageButton(imageName: "plus.circle", configImagePointSize: 35)
    private var dates = [Date]()
    private var selectedDate: Date?


    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCollectionViewAppearance()
    }
}

// MARK: - Private functions
private extension PlantsTasksViewController {
    func initialize() {
        view.backgroundColor = .accentDark
        title = "Plants Tasks"
        setupViews()
    }

    private func setupCollectionViewAppearance(){
        datePickerCollectionView.layer.cornerRadius = datePickerCollectionView.frame.size.height / 12
        datePickerCollectionView.layer.masksToBounds = true
        datePickerCollectionView.layer.borderWidth = 1
        datePickerCollectionView.layer.borderColor = UIColor.accentLight.cgColor
    }

    private func setupViews() {
        datePickerCollectionView = createCollectionView()
        datePickerCollectionView.dataSource = self
        datePickerCollectionView.delegate = self
        datePickerCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "\(CalendarCell.self)")

        [dateLabel, todayButton, addTaskButton, datePickerCollectionView].forEach { item in
            view.addSubview(item)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
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
        }

        addTaskButton.snp.makeConstraints { make in
            make.top.equalTo(datePickerCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        todayButton.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)

    }

    private func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionLayout())
        collectionView.backgroundColor = .accentLight
        collectionView.isPagingEnabled = true
        return collectionView
    }

    private func createCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2
        return layout
    }

    private func scrollToSelectedDate(animated: Bool) {
        guard let selectedIndex = dates.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: selectedDate ?? Date()) }) else { return }
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        datePickerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }

    //MARK: - Selectors
    @objc private func todayButtonTapped(){
        presenter?.todayButtonTapped()
    }
}

extension PlantsTasksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CalendarCell.self)", for: indexPath) as? CalendarCell else {
            return UICollectionViewCell()
        }

        let date = dates[indexPath.item]
        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate ?? Date())
        cell.configure(with: date, isSelected: isSelected)
        return cell
    }
}

extension PlantsTasksViewController: UICollectionViewDelegateFlowLayout {
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


extension PlantsTasksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dates[indexPath.item]
        presenter?.didSelectDate(date: selectedDate)
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


// MARK: - PlantsTasksViewProtocol
extension PlantsTasksViewController: PlantsTasksViewProtocol {
    func setDates(dates: [Date]) {
        self.dates = dates
        datePickerCollectionView.reloadData()
    }

    func setCurrentDate(date: Date) {
        selectedDate = date
    }

    func setCurrentDateLabel(date: String) {
        dateLabel.text = date
    }

    func refreshCollectionViewAndScrollToCurrentDate() {
        datePickerCollectionView.reloadData()
        scrollToSelectedDate(animated: true)
    }
}
