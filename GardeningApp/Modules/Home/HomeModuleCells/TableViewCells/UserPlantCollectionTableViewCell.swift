//
//
// GardeningApp
// UserPlantCollectionTableViewCell.swift
//
// Created by Alexander Kist on 23.01.2024.
//


import UIKit
import SnapKit

class UserPlantCollectionTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: UserPlantCollectionTableViewCellModel.self)

    var plants: [PlantViewModel]

    init(plants: [PlantViewModel]) {
        self.plants = plants
    }
}

class UserPlantCollectionTableViewCell: UITableViewCell, HomeTableViewCellItem {

    weak var delegate: HomeTableViewCellItemDelegate?
    private var cellData: [PlantViewModel] = []

    func config(with data: Any) {
        guard let data = data as? UserPlantCollectionTableViewCellModel else { return }
        contentView.backgroundColor = .light
        cellData = data.plants
        gardenCollectionView.reloadData()
    }


    private lazy var gardenCollectionView = UICollectionView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        gardenCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gardenCollectionView.register(PlantCell.self, forCellWithReuseIdentifier: "\(PlantCell.self)")
        gardenCollectionView.backgroundColor = .light
        gardenCollectionView.showsVerticalScrollIndicator = false
        gardenCollectionView.showsHorizontalScrollIndicator = false

        gardenCollectionView.dataSource = self
        gardenCollectionView.delegate = self

        contentView.addSubview(gardenCollectionView)

        gardenCollectionView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(250)
        }
    }
}


extension UserPlantCollectionTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PlantCell.self)", for: indexPath) as? PlantCell else {
            return UICollectionViewCell()
        }
        let plant = cellData[indexPath.row]
        cell.configureCell(with: plant)
        return cell
    }
}

extension UserPlantCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let leftInset = flowLayout.sectionInset.left
        let rightInset = flowLayout.sectionInset.right
        let totalHorizontalInset = leftInset + rightInset
        let topInset = flowLayout.sectionInset.top
        let bottomInset = flowLayout.sectionInset.bottom
        let totalVerticalInset = topInset + bottomInset

        let availableWidth = collectionView.bounds.width - totalHorizontalInset
        let widthPerItem = availableWidth / 1.5
        let heightPerItem = collectionView.bounds.height - totalVerticalInset
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
}


extension UserPlantCollectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let plant = cellData[indexPath.row]
        delegate?.didTapOpenGardenInfo(self, plant: plant)
    }
}
