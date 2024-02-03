//
// GardeningApp
// TasksPresenter.swift
//
// Created by Alexander Kist on 15.01.2024.
//

import Foundation

protocol TasksPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didFetchData(with data: TaskListTableViewData)
    func addTaskButtonTapped()
    func didSelectDate(with date: Date)
    func didFetchTasksForDate(_ tasks: [TaskRealmObject])
    func todayButtonTapped()
    func completeButtonTapped(forTaskId id: String)
    func taskStatusChanged(forTaskID id: String, for task: TaskRealmObject)
}

class TasksPresenter {
    weak var view: TasksViewProtocol?
    var router: TasksRouterProtocol
    var interactor: TasksInteractorProtocol

    init(interactor: TasksInteractorProtocol, router: TasksRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension TasksPresenter: TasksPresenterProtocol {

    private enum Constants{
        static let imagePointSize: CGFloat = 40
        static let addTaskButtonImageName = "plus.circle"
        static let todayButtonTitle = "Today"
        static let dateFormat = "MMMM dd, yyyy"
    }

    func viewDidLoad() {
        interactor.fetchInitialData()
    }

    func didFetchData(with data: TaskListTableViewData) {
        let tableData = configureFetchedData(from: data)
        let cellModels = setupCells(from: tableData)
        view?.setCells(with: cellModels)
    }

    func todayButtonTapped() {
        interactor.setCurrentDate()
        let today = interactor.loadCurrentDate()
        DispatchQueue.main.async {
            self.view?.scrollDatePickerToToday(with: today)
        }
    }

    func addTaskButtonTapped() {
        router.openAddTaskVC()
    }

    func completeButtonTapped(forTaskId id: String) {
        interactor.updatePlantTaskStatus(with: id)
    }

    func taskStatusChanged(forTaskID id: String, for task: TaskRealmObject) {
        let taskVM = convertToTaskViewModel(task: task)
        let cellModel = getTaskCellModel(task: taskVM)
        DispatchQueue.main.async {
            self.view?.updateTask(forId: id, withModel: cellModel)
        }
    }

    func didSelectDate(with date: Date) {
        let selectedDate = convertDateToString(date: date)
        view?.updateCurrentDateLabel(with: selectedDate)
        view?.scrollDatePickerToChosenDate(with: date)
        interactor.fetchPlantsTaskForChosenDate(for: date)
    }

    func didFetchTasksForDate(_ tasks: [TaskRealmObject]) {
        let taskViewModels = getTasksModels(tasks: tasks)
        let taskCellModels = taskViewModels.map { TaskTableViewCellModel(task: $0)}
        view?.updateTasks(with: taskCellModels)
    }

    private func convertToTaskViewModel(task: TaskRealmObject) -> TaskViewModel {
        let plantName = task.plant.first?.plantName ?? ""
        let plantId = task.plant.first?.id.stringValue
        return TaskViewModel(id: task.id.stringValue,
                             plantName: plantName,
                             plantID: plantId,
                             taskType: task.taskType,
                             dueDate: convertDateToString(date: task.dueDate),
                             taskDescription: task.taskDescription,
                             isComplete: task.isComplete
        ) 
    }

    private func configureFetchedData(from data: TaskListTableViewData) -> TaskListTableViewModel {
        return TaskListTableViewModel(
            currentDate: convertDateToString(date: data.currentDate),
            dates: data.dates,
            tasks: getTasksModels(tasks: data.tasks)
        )
    }

    private func getTaskCellModel(task: TaskViewModel) -> TaskTableViewCellModel {
        return TaskTableViewCellModel(task: task)
    }

    private func getTasksModels(tasks: [TaskRealmObject]) -> [TaskViewModel]{
        let taskModels = tasks.map { taskRealm in
            let dueDate = convertDateToString(date: taskRealm.dueDate)
            let plantName = taskRealm.plant.first?.plantName ?? ""
            let plantId = taskRealm.plant.first?.id.stringValue
            return TaskViewModel(
                id: taskRealm.id.stringValue,
                plantName: plantName,
                plantID: plantId,
                taskType: taskRealm.taskType,
                dueDate: dueDate,
                taskDescription: taskRealm.taskDescription,
                isComplete: taskRealm.isComplete
            )
        }
        return taskModels
    }

    private func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        return formatter.string(from: date)
    }

    private func setupCells(from data: TaskListTableViewModel) -> [TableViewCellItemModel] {
        var cellModels: [TableViewCellItemModel] = [
            CurrentDateTableViewCellModel(labelText: data.currentDate, todayButtonTitle: Constants.todayButtonTitle),
            DatePickerTableViewCellModel(dates: data.dates, selectedDate: Date()),
            AddTaskButtonTableViewCellModel(imageName: Constants.addTaskButtonImageName, imagePointSize: Constants.imagePointSize)
        ]

        for task in data.tasks {
            let taskCellModel = TaskTableViewCellModel(task: task)
            cellModels.append(taskCellModel)
        }
        return cellModels
    }
}
