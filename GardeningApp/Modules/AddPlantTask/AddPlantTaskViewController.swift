//
// GardeningApp
// AddPlantTaskViewController.swift
//
// Created by Alexander Kist on 05.01.2024.
//

import UIKit
import SnapKit

protocol AddPlantTaskViewProtocol: AnyObject {
    func setCells(with items: [TableViewCellItemModel])
}

class AddPlantTaskViewController: UITableViewController {
    // MARK: - Public
    var presenter: AddPlantTaskPresenterProtocol?

    var items: [TableViewCellItemModel] = []
    var taskData = TaskModel()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupView()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: items[indexPath.row].identifier) as? AddPlantTableViewCellItem
        cell?.config(with: items[indexPath.row])
        cell?.delegate = self
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

// MARK: - Private functions
private extension AddPlantTaskViewController {
    func initialize() {
        view.backgroundColor = .accentDark
        registerCells()
    }

    private func setupView(){
        title = "Add Task"

        tableView.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
    }

    private func registerCells(){
        tableView.register(PlantsNamesCollectionTableViewCell.self, forCellReuseIdentifier: "\(PlantsNamesCollectionTableViewCellModel.self)")
        tableView.register(SaveTaskButtonTableViewCell.self, forCellReuseIdentifier:  "\(SaveTaskButtonTableViewCellModel.self)")
        tableView.register(TaskTypesCollectionTableViewCell.self, forCellReuseIdentifier: "\(TaskTypesCollectionTableViewCellModel.self)")
        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: "\( DatePickerTableViewCellModel.self)")
        tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier:"\( TextViewTableViewCellModel.self)")
    }
}

// MARK: - AddPlantTaskViewProtocol
extension AddPlantTaskViewController: AddPlantTaskViewProtocol {
    func setCells(with items: [TableViewCellItemModel]) {
        self.items = items
        tableView.reloadData()
    }
}

extension AddPlantTaskViewController: AddTaskTableViewItemDelegate {
    func didSelectPlantName(_ cell: PlantsNamesCollectionTableViewCell, withName name: String) {
        taskData.plantName = name
    }
    
    func didSelectTaskType(_ cell: TaskTypesCollectionTableViewCell, withType type: String) {
        taskData.taskType = type
    }
    
    func didSelectDate(_ cell: DatePickerTableViewCell, withDate date: Date) {
        taskData.dueDate = date
    }
    
    func didWriteDescription(_ cell: TextViewTableViewCell, withText text: String) {
        taskData.taskDescription = text
    }

    func buttonCellDidTapped(_ cell: SaveTaskButtonTableViewCell) {
        presenter?.saveTaskData(with: taskData)
        presenter?.dismissVC()
    }
}
