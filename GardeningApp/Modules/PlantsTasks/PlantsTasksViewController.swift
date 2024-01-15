//
// GardeningApp
// PlantsTasksViewController.swift
//
// Created by Alexander Kist on 22.12.2023.
//

import UIKit
import SwiftUI
import SnapKit

protocol PlantsTasksViewProtocol: AnyObject {
    func setDates(dates: [Date])
    func setTasks(tasks: [TaskModel])
    func setCurrentDate(date: Date)
    func setCurrentDateLabel(date: String)
    func refreshCollectionViewAndScrollToCurrentDate()
}

class PlantsTasksViewController: UIViewController {
    // MARK: - Public
    var presenter: PlantsTasksPresenterProtocol?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let dateLabel = CustomLabel(fontName: UIFont.body(), textColor: .accentLight)
    private let todayButton = CustomTextButton(text: "Today", bgColor: .accentDark)

    private lazy var datePickerCollectionView = UICollectionView()
    private lazy var userTaskCollectionView = UICollectionView()

    private let addTaskButton = CustomImageButton(imageName: "plus.circle", configImagePointSize: 40)

    private var dates = [Date]()
    private var tasks = [TaskModel]()
    private var selectedDate: Date?

    private var userTaskCollectionViewHeight: Constraint?


    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.viewDidLoad()
        view.layoutIfNeeded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollViewContentSize()
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
    

    private func  updateScrollViewContentSize() {
        userTaskCollectionView.collectionViewLayout.invalidateLayout()
        userTaskCollectionView.layoutIfNeeded()
        userTaskCollectionViewHeight?.update(offset: userTaskCollectionView.contentSize.height)
    }

    private func setupCollectionViewAppearance(){
        setCollectionLayer(collectionView: datePickerCollectionView, cornerRadiusDivider: 12, borderWidth: 1, borderColor: UIColor.accentLight.cgColor)
    }

    private func setupDatePicker(){
        let insets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        datePickerCollectionView = createCollectionView(direction: .horizontal, isPagingEnabled: true, bgColor: .accentLight, insets: insets, lineSpacing: 0, itemSpacing: 2)
        datePickerCollectionView.dataSource = self
        datePickerCollectionView.delegate = self
        datePickerCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "\(CalendarCell.self)")
        datePickerCollectionView.tag = 0
    }

    private func setupUserTasks(){
        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        userTaskCollectionView = createCollectionView(direction: .vertical, isPagingEnabled: false, bgColor: .accentDark, insets: insets, lineSpacing: 10, itemSpacing: 0)
        userTaskCollectionView.dataSource = self
        userTaskCollectionView.delegate = self
        userTaskCollectionView.isScrollEnabled = false
        userTaskCollectionView.register(TaskCell.self, forCellWithReuseIdentifier: "\(TaskCell.self)")
        userTaskCollectionView.tag = 1
    }

    private func setCollectionLayer(collectionView: UICollectionView, cornerRadiusDivider: CGFloat?, borderWidth: CGFloat, borderColor: CGColor){
        if let cornerRadiusDivider = cornerRadiusDivider {
            collectionView.layer.cornerRadius = collectionView.frame.size.height / cornerRadiusDivider
            collectionView.layer.masksToBounds = true
            collectionView.layer.borderWidth = borderWidth
            collectionView.layer.borderColor =  borderColor
        } else {
            collectionView.layer.cornerRadius = 0
        }
    }

    private func setupViews() {

        setupDatePicker()
        setupUserTasks()
        scrollView.showsVerticalScrollIndicator = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }

        [dateLabel, todayButton, addTaskButton, datePickerCollectionView, userTaskCollectionView].forEach { item in
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
        }

        addTaskButton.snp.makeConstraints { make in
            make.top.equalTo(datePickerCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        userTaskCollectionView.snp.makeConstraints { make in
            make.top.equalTo(addTaskButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
            self.userTaskCollectionViewHeight = make.height.equalTo(userTaskCollectionView.contentSize.height).constraint
        }

        todayButton.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
        addTaskButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

    }




    private func createCollectionView(direction: UICollectionView.ScrollDirection, isPagingEnabled: Bool, bgColor: UIColor, insets: UIEdgeInsets, lineSpacing: CGFloat, itemSpacing: CGFloat) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionLayout(direction: direction, insets: insets, lineSpacing: lineSpacing, itemSpacing:  itemSpacing))
        collectionView.backgroundColor = bgColor
        collectionView.isPagingEnabled = isPagingEnabled
        return collectionView
    }

    private func createCollectionLayout(direction: UICollectionView.ScrollDirection, insets: UIEdgeInsets, lineSpacing: CGFloat, itemSpacing: CGFloat) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = direction
        layout.sectionInset = insets
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
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

    @objc private func addButtonTapped(){
        presenter?.addTaskButtonTapped()
    }
}

extension PlantsTasksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return dates.count
        case 1:
            return tasks.count
        default:
            return 0
        }
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CalendarCell.self)", for: indexPath) as? CalendarCell else {
                return UICollectionViewCell()
            }

            let date = dates[indexPath.item]
            let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate ?? Date())
            cell.configure(with: date, isSelected: isSelected)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TaskCell.self)", for: indexPath) as? TaskCell else {
                return UICollectionViewCell()
            }
            let task = tasks[indexPath.item]
            cell.configure(with: task)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension PlantsTasksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        switch collectionView.tag {
        case 0:
            let leftInset = flowLayout.sectionInset.left
            let rightInset = flowLayout.sectionInset.right
            let totalInset = leftInset + rightInset

            let availableWidth = collectionView.bounds.width - totalInset
            let widthPerItem = availableWidth / 7
            let height = collectionView.bounds.height - (flowLayout.sectionInset.top + flowLayout.sectionInset.bottom)

            return CGSize(width: widthPerItem, height: height)
        case 1:
            let height: CGFloat  = 180
            let width = collectionView.bounds.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right)
            return CGSize(width: width, height: height)
        default:
            return CGSize.zero
        }
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

    func setTasks(tasks: [TaskModel]) {
        self.tasks = tasks
        userTaskCollectionView.reloadData()
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
