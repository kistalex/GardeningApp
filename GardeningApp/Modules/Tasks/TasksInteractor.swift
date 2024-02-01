//
// GardeningApp
// TasksInteractor.swift
//
// Created by Alexander Kist on 15.01.2024.
//

import Foundation
import RealmSwift

protocol TasksInteractorProtocol: AnyObject {
    func fetchInitialData()
    func setCurrentDate()
    func loadCurrentDate()-> Date
    func fetchPlantsTaskForChosenDate(for date: Date)
    func fetchPlantsTasksForToday() -> [TaskRealmObject]
    //    func fetchPlantsTasks(for date: Date) -> [TaskRealmObject]
    func updatePlantTaskStatus(with id: String)
}

class TasksInteractor: TasksInteractorProtocol {

    weak var presenter: TasksPresenterProtocol?

    private var realm: Realm?

    private var currentDate = Date()
    private var notificationToken: NotificationToken?

    private let realmManager: RealmManager<TaskRealmObject>

    private enum Constants {
        static var realmDateFilter: String = "dueDate >= %@ AND dueDate <= %@"
    }

    init(realmManager: RealmManager<TaskRealmObject>){
        self.realmManager = realmManager
        setupTaskChangeNotifications()
    }


    func setCurrentDate() {
        let currentDate = loadCurrentDate()
        presenter?.didSelectDate(with: currentDate)
    }

    func fetchInitialData() {
        let dates = countDates()
        let tasks = fetchPlantsTasksForToday()
        let currentDate = currentDate
        let data = TaskListTableViewData(currentDate: currentDate, dates: dates, tasks: tasks)
        presenter?.didFetchData(with: data)
    }

    func updatePlantTaskStatus(with id: String) {
        realmManager.updateTaskStatus(taskId: id) { [weak self] result in
            switch result {
            case .success(let task):
                self?.presenter?.taskStatusChanged(forTaskID: task.id.stringValue, for: task)
            case .failure(let error):
                print("Failed to complete task: \(error.localizedDescription)")
            }
        }
    }

    func fetchPlantsTasksForToday() -> [TaskRealmObject]{
        let tasks = fetchPlantsTasks(for: currentDate)
        return tasks
    }

    func loadCurrentDate() -> Date {
        let today = Date()
        return today
    }

    func fetchPlantsTaskForChosenDate(for date: Date){
        let tasks = fetchPlantsTasks(for: date)
        presenter?.didFetchTasksForDate(tasks)
    }

    private func fetchPlantsTasks(for date: Date) -> [TaskRealmObject]{
        let tasks = realmManager.fetchObjects(for: date, with: Constants.realmDateFilter)
        return tasks
    }

    private func countDates() -> [Date] {
        var dates = [Date]()
        var calendar = Calendar.current
        calendar.firstWeekday = 2

        let today = Date()

        if let currentWeekdayComponent = calendar.dateComponents([.weekday], from: today).weekday,
           let startOfThisWeek = calendar.date(byAdding: .day, value: -(currentWeekdayComponent - calendar.firstWeekday + 7) % 7, to: today),
           let endOfNextMonth = calendar.date(byAdding: .month, value: 2, to: today),
           let lastDayOfNextMonth = calendar.date(byAdding: .day, value: -1, to: endOfNextMonth),
           let weekdayComponent = calendar.dateComponents([.weekday], from: lastDayOfNextMonth).weekday,
           let endOfCalendar = calendar.date(byAdding: .day, value: (7 - weekdayComponent + calendar.firstWeekday) % 7, to: lastDayOfNextMonth) {

            var currentDate = startOfThisWeek
            while currentDate <= endOfCalendar {
                dates.append(currentDate)
                if let newDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                    currentDate = newDate
                } else {
                    break
                }
            }
        }
        return dates
    }

    private func setupTaskChangeNotifications() {
        notificationToken = realmManager.setupChangeNotifications(
            onUpdate: { [weak self] (updatedTasks, changes) in
                guard let self = self else { return }
                switch changes {
                case .update(_, _, let insertions, _):
                    insertions.forEach { index in
                        let task = updatedTasks[index]
                        let date = task.dueDate
                        self.presenter?.didSelectDate(with: date)
                    }
                default:
                    break
                }
            }
        )
    }
}
