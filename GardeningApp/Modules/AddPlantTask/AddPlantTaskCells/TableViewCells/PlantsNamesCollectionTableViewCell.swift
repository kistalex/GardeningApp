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

    init(plantsNames: [String], labelText: String) {
        self.plantsNames = plantsNames
        self.labelText = labelText
    }
}

final class PlantsNamesCollectionTableViewCell: UITableViewCell, AddPlantTableViewCellItem {

    weak var delegate: AddTaskTableViewItemDelegate?

    private let label = UILabel()
    private var collectionView: UICollectionView!
    private var cellData: [String] = []

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
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(StringCollectionViewCell.self, forCellWithReuseIdentifier: "\(StringCollectionViewCell.self)")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self

        contentView.addSubview(label)
        contentView.addSubview(collectionView)

        label.numberOfLines = 0

        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }

    func config(with data: Any) {
        guard let data = data as? PlantsNamesCollectionTableViewCellModel else { return }
        contentView.backgroundColor = .accentDark
        label.textColor = .accentLight
        label.text = data.labelText
        cellData = data.plantsNames
        
        collectionView.reloadData()
    }
}
    // MARK: UICollectionViewDataSource
extension PlantsNamesCollectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(StringCollectionViewCell.self)", for: indexPath) as? StringCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: cellData[indexPath.row])
        return cell
    }
}

extension PlantsNamesCollectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedName = cellData[indexPath.row]
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.didSelectPlantName(self, withName: selectedName)
    }
}
extension PlantsNamesCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame
        let categoryFont = UIFont.body()
        let categoryAttributes = [NSAttributedString.Key.font: categoryFont as Any]
        let categoryWidth = cellData[indexPath.item].size(withAttributes: categoryAttributes).width
        return CGSize(width: categoryWidth + 30 , height: size.height - 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
}


