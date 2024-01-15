//
// GardeningApp
// PlantsTasksPresenter.swift
//
// Created by Alexander Kist on 22.12.2023.
//

import UIKit

protocol PlantsTasksPresenterProtocol: AnyObject {
    func datesFetched(dates: [Date])
    func tasksFetched(tasks: [Int])

    func plantsTasksFetched(tasks: [TaskRealmObject])

    func viewDidLoad()
    func setCurrentDate(date: Date)
    func didSelectDate(date: Date?)
    func todayButtonTapped()
    func addTaskButtonTapped()
}

class PlantsTasksPresenter {
    weak var view: PlantsTasksViewProtocol?
    var router: PlantsTasksRouterProtocol
    var interactor: PlantsTasksInteractorProtocol

    init(interactor: PlantsTasksInteractorProtocol, router: PlantsTasksRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension PlantsTasksPresenter: PlantsTasksPresenterProtocol {

    func viewDidLoad() {
        interactor.fetchCurrentDate()
        interactor.fetchDates()
        interactor.fetchPlantsTasks()
    }
    
    func plantsTasksFetched(tasks: [TaskRealmObject]){
        let taskModels = tasks.map { taskRealm in
            let plantName = taskRealm.plant.first?.plantName ?? ""
            return TaskModel(plantName: plantName, taskType: taskRealm.taskType, dueDate: taskRealm.dueDate, taskDescription: taskRealm.taskDescription)
        }

        view?.setTasks(tasks: taskModels)
    }
    
    func formatToString(date: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date ?? Date())
        return dateString
    }

    func datesFetched(dates: [Date]) {
        view?.setDates(dates: dates)
    }

    func tasksFetched(tasks: [Int]) {
//        view?.setTasks(tasks: tasks)
    }

    func setCurrentDate(date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        view?.setCurrentDateLabel(date: dateFormatter.string(from: date))
        view?.setCurrentDate(date: date)
    }
    func didSelectDate(date: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        view?.setCurrentDateLabel(date: dateFormatter.string(from: date ?? Date()))
    }

    func todayButtonTapped() {
        interactor.fetchCurrentDate()
        view?.refreshCollectionViewAndScrollToCurrentDate()
    }

    func addTaskButtonTapped() {
        router.openAddTaskVC()
    }
}
