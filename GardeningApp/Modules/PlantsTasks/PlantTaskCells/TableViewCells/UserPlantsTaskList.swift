//
//
// GardeningApp
// UserPlantsTaskList.swift
// 
// Created by Alexander Kist on 15.01.2024.
//


import Foundation
import UIKit

final class UserPlantsTaskListTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: UserPlantsTaskListTableViewCellModel.self)

    var tasks: [TaskModel]

    init(tasks: [TaskModel]) {
        self.tasks = tasks
    }
}

final class UserPlantsTaskListTableViewCell: UITableViewCell, PlantTaskTableViewCellItem {

    weak var delegate: PlantTaskTableViewItemDelegate?

    private var taskListCollectionView: UICollectionView!
    private var cellData = [TaskModel]()

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
        taskListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        taskListCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "\(CalendarCell.self)")
        taskListCollectionView.backgroundColor = .clear
        taskListCollectionView.showsHorizontalScrollIndicator = false
        taskListCollectionView.dataSource = self
        taskListCollectionView.isPagingEnabled = true
        taskListCollectionView.backgroundColor = .accentLight

        contentView.addSubview(taskListCollectionView)


        taskListCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func config(with data: Any) {
        guard let data = data as? UserPlantsTaskListTableViewCellModel else { return }
        contentView.backgroundColor = .accentDark
        cellData = data.tasks
        taskListCollectionView.reloadData()
    }


}
    // MARK: UICollectionViewDataSource
extension UserPlantsTaskListTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TaskCell.self)", for: indexPath) as? TaskCell else {
            return UICollectionViewCell()
        }

        let task = cellData[indexPath.item]
        cell.configure(with: task)
        return cell
    }
}



//struct DatePickerCellContentViewPreview: PreviewProvider {
//    struct DatePickerCellContent: UIViewRepresentable {
//        func makeUIView(context: Context) -> some UIView {
//            DatePickerCollectionTableViewCell()
//        }
//        func updateUIView(_ uiView: UIViewType, context: Context) {}
//    }
//
//    static var previews: some View {
//        let size = UIScreen.main.bounds
//        DatePickerCellContent()
//            .padding(5)
//            .frame(width: size.width, height: size.height / 5)
//    }
//}
