//
//
// GardeningApp
// TaskTypesCollectionTableViewCell.swift
// 
// Created by Alexander Kist on 09.01.2024.
//


import UIKit
import SnapKit

final class TaskTypesCollectionTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: TaskTypesCollectionTableViewCellModel.self)

    var labelText: String
    var taskTypes: [String]

    init(taskTypes: [String], labelText: String) {
        self.taskTypes = taskTypes
        self.labelText = labelText
    }
}

final class TaskTypesCollectionTableViewCell: UITableViewCell, AddTaskTableViewCellItem {

    weak var delegate: AddTaskTableViewItemDelegate?

    func config(with data: Any) {
        guard let data = data as? TaskTypesCollectionTableViewCellModel else { return }
        contentView.backgroundColor = Constants.contentViewBgColor
        label.text = data.labelText
        label.textColor = Constants.textColor
        label.numberOfLines = 0
        cellData = data.taskTypes
        collectionView.reloadData()
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
        static let textFont = UIFont.body()
        static let textColor: UIColor = .dark
        static let collectionViewBgColor: UIColor = .clear
        static let labelTopInset: CGFloat = 16
        static let labelHorizontalInset: CGFloat = 10
        static let collectionTopInset: CGFloat = 10
        static let collectionHeightConstraint: CGFloat = 50
        static let collectionSectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        static let collectionItemInternalHorizontalMargin: CGFloat = 30
        static let collectionItemInternalVerticalMargin: CGFloat = 10
        static let contentViewBgColor: UIColor = .light
    }

    private let label = UILabel()
    private var collectionView: UICollectionView!
    private var cellData: [String] = []
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(TaskTypeCollectionCell.self, forCellWithReuseIdentifier: "\(TaskTypeCollectionCell.self)")
        collectionView.backgroundColor = Constants.collectionViewBgColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self

        contentView.addSubview(label)
        contentView.addSubview(collectionView)


        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.labelTopInset)
            make.horizontalEdges.equalToSuperview().inset(Constants.labelHorizontalInset)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(Constants.collectionTopInset)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(Constants.collectionHeightConstraint)
        }
    }


}
extension TaskTypesCollectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TaskTypeCollectionCell.self)", for: indexPath) as? TaskTypeCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: cellData[indexPath.row])
        return cell
    }
}

extension TaskTypesCollectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedType = cellData[indexPath.row]
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.didSelectTaskType(self, withType: selectedType)
    }
}
extension TaskTypesCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame
        let categoryFont = Constants.textFont
        let categoryAttributes = [NSAttributedString.Key.font: categoryFont as Any]
        let categoryWidth = cellData[indexPath.item].size(withAttributes: categoryAttributes).width
        return CGSize(
            width: categoryWidth + Constants.collectionItemInternalHorizontalMargin,
            height: size.height - Constants.collectionItemInternalVerticalMargin
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.collectionSectionInset
    }
}
