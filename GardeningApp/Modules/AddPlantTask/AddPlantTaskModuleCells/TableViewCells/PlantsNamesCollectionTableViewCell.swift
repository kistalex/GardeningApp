//
//
// GardeningApp
// PlantsNamesCollectionTableViewCell.swift
// 
// Created by Alexander Kist on 09.01.2024.
//


import UIKit
import RealmSwift
import SnapKit

final class PlantsNamesCollectionTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: PlantsNamesCollectionTableViewCellModel.self)

    var labelText: String
    var plantsNames: [String]
    var plantIds: [String]

    init(plantIDs: [String],plantsNames: [String], labelText: String) {
        self.plantIds = plantIDs
        self.plantsNames = plantsNames
        self.labelText = labelText
    }
}

final class PlantsNamesCollectionTableViewCell: UITableViewCell, AddTaskTableViewCellItem {

    weak var delegate: AddTaskTableViewItemDelegate?

    func config(with data: Any) {
        guard let data = data as? PlantsNamesCollectionTableViewCellModel else { return }
        contentView.backgroundColor = Constants.contentViewBgColor
        label.textColor = Constants.textColor
        label.text = data.labelText
        label.numberOfLines = 0
        plantNames = data.plantsNames
        plantIds = data.plantIds
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
    private var plantNames: [String] = []
    private var plantIds: [String] = []

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(PlantTypeCollectionCell.self, forCellWithReuseIdentifier: "\(PlantTypeCollectionCell.self)")
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
extension PlantsNamesCollectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plantNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PlantTypeCollectionCell.self)", for: indexPath) as? PlantTypeCollectionCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: plantNames[indexPath.row])
        return cell
    }
}

extension PlantsNamesCollectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedId = plantIds[indexPath.row]
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.didSelectPlant(self, withId: selectedId)
        
    }
}
extension PlantsNamesCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame
        let categoryFont = Constants.textFont
        let categoryAttributes = [NSAttributedString.Key.font: categoryFont as Any]
        let categoryWidth = plantNames[indexPath.item].size(withAttributes: categoryAttributes).width
        return CGSize(
            width: categoryWidth + Constants.collectionItemInternalHorizontalMargin,
            height: size.height - Constants.collectionItemInternalVerticalMargin
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.collectionSectionInset
    }
}


