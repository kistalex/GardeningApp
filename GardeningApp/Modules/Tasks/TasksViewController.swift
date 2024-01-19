//
// GardeningApp
// TasksViewController.swift
//
// Created by Alexander Kist on 15.01.2024.
//

import UIKit

protocol TasksViewProtocol: AnyObject {
    func setCells(with items: [TableViewCellItemModel])
    func updateCurrentDateLabel(with text: String)
    func scrollDatePickerToToday(with date: Date)
    func scrollDatePickerToChosenDate(with date: Date)
    func updateTasks(with tasks: [TaskTableViewCellModel])
    func updateTask(forId id: String, withModel model: TaskTableViewCellModel)
}

class TasksViewController: UITableViewController {
    // MARK: - Public
    var presenter: TasksPresenterProtocol?

    private var items = [TableViewCellItemModel]()


    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        initialize()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: items[indexPath.row].identifier) as? TaskTableViewCellItem
        cell?.config(with: items[indexPath.row])
        cell?.delegate = self
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

// MARK: - Private functions
private extension TasksViewController {
    func initialize() {
        view.backgroundColor = .light
        registerCells()
        setupView()
    }

    private func setupView(){
        title = "Task List"

        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
    }

    private func registerCells(){
        tableView.register(CurrentDateTableViewCell.self, forCellReuseIdentifier: "\(CurrentDateTableViewCellModel.self)")
        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: "\(DatePickerTableViewCellModel.self)")
        tableView.register(AddTaskButtonTableViewCell.self, forCellReuseIdentifier:  "\(AddTaskButtonTableViewCellModel.self)")
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "\(TaskTableViewCellModel.self)")
    }
}

extension TasksViewController: TaskTableViewItemDelegate {


    func didSelectDate(_ cell: DatePickerTableViewCell, with date: Date?) {
        presenter?.didSelectDate(with: date ?? Date())
    }

    func buttonCellDidTap(_ cell: AddTaskButtonTableViewCell) {
        presenter?.addTaskButtonTapped()
    }

    func todayButtonDidTap(_ cell: CurrentDateTableViewCell) {
        presenter?.todayButtonTapped()
    }

    func completeButtonDidTap(_ cell: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let taskModel = items[indexPath.row] as? TaskTableViewCellModel
        guard let taskId = taskModel?.task.id else { return }
        presenter?.completeButtonTapped(forTaskId: taskId)
    }

}

// MARK: - TasksViewProtocol
extension TasksViewController: TasksViewProtocol {

    func setCells(with items: [TableViewCellItemModel]) {
        self.items = items
        tableView.reloadData()
    }

    func updateCurrentDateLabel(with text: String) {
        if let index = items.firstIndex(where: { $0 is CurrentDateTableViewCellModel }) {
            if let currentDateModel = items[index] as? CurrentDateTableViewCellModel {
                currentDateModel.labelText = text
                items[index] = currentDateModel
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }

    func scrollDatePickerToToday(with date: Date) {
        if let datePickerIndex = items.firstIndex(where: { $0 is DatePickerTableViewCellModel }),
           let datePickerModel = items[datePickerIndex] as? DatePickerTableViewCellModel {
            datePickerModel.selectedDate = date
            let indexPath = IndexPath(row: datePickerIndex, section: 0)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }

    func scrollDatePickerToChosenDate(with date: Date) {
        if let datePickerIndex = items.firstIndex(where: { $0 is DatePickerTableViewCellModel }),
           let datePickerModel = items[datePickerIndex] as? DatePickerTableViewCellModel {
            datePickerModel.selectedDate = date
        }
    }

    func updateTasks(with tasks: [TaskTableViewCellModel]) {
        items.removeAll(where: { $0 is TaskTableViewCellModel })
        if let addTaskButtonIndex = items.firstIndex(where: { $0 is AddTaskButtonTableViewCellModel }) {
            let taskCellIndex = addTaskButtonIndex + 1
            items.insert(contentsOf: tasks, at: taskCellIndex)
        } else {
            items.append(contentsOf: tasks)
        }
        tableView.reloadData()
    }

    func updateTask(forId id: String, withModel model: TaskTableViewCellModel) {
        if let index = items.firstIndex(where: { ($0 as? TaskTableViewCellModel)?.task.id == id }) {
            if let taskModel = items[index] as? TaskTableViewCellModel {
                taskModel.task = model.task
                let indexPath = IndexPath(row: index, section: 0)
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}


