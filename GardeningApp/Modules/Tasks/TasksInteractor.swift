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
    func fetchPlantsTasks(for date: Date) -> [TaskRealmObject]
    func updatePlantTaskStatus(with id: String)
}

class TasksInteractor: TasksInteractorProtocol {

    weak var presenter: TasksPresenterProtocol?

    private var realm: Realm?

    private var currentDate = Date()
    private var notificationToken: NotificationToken?


    private enum Constants {
        static var realmDateFilter: String = "dueDate >= %@ AND dueDate <= %@"
    }

    init(){
        do {
            realm = try Realm()
        } catch let error {
            print("Failed to instantiate Realm: \(error.localizedDescription)")
            realm = nil
        }
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
        guard let realm = realm else { return }
        guard let objectID = try? ObjectId(string: id) else { return }
        guard let task = realm.object(ofType: TaskRealmObject.self, forPrimaryKey: objectID) else { return }

        do {
            try realm.write {
                task.isComplete.toggle()
                presenter?.taskStatusChanged(forTaskID: task.id.stringValue, for: task)
            }
        } catch {
            print("Failed to complete task: \(error.localizedDescription)")
        }
    }

    func fetchPlantsTasksForToday() -> [TaskRealmObject]{
        let tasks = fetchPlantsTasks(for: currentDate)
        return tasks
    }

    func loadCurrentDate()->Date {
        let today = Date()
        return today
    }

    func fetchPlantsTaskForChosenDate(for date: Date){
        let tasks = fetchPlantsTasks(for: date)
        presenter?.didFetchTasksForDate(tasks)
    }

    func fetchPlantsTasks(for date: Date) -> [TaskRealmObject]{
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: startOfDay)!
        }()

        let predicate = NSPredicate(format: Constants.realmDateFilter, startOfDay as NSDate, endOfDay as NSDate)
        let plantsTasks = realm?.objects(TaskRealmObject.self).filter(predicate)

        guard let tasks = plantsTasks else { return [] }
        return Array(tasks)
    }


    private func countDates() -> [Date] {
        var dates = [Date]()
        var calendar = Calendar.current
        calendar.firstWeekday = 2

        let today = Date()

        if let currentWeekdayComponent = calendar.dateComponents([.weekday], from: today).weekday,
           let startOfThisWeek = calendar.date(byAdding: .day, value: -(currentWeekdayComponent - calendar.firstWeekday + 7) % 7, to: today) {

            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: today),
               let endOfNextMonth = calendar.date(byAdding: .month, value: 1, to: nextMonth),
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
        }
        return dates
    }

    private func setupTaskChangeNotifications() {
        guard let realm = realm else { return }
        let tasks = realm.objects(TaskRealmObject.self)
        notificationToken = tasks.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .initial:
                break
            case .update(_, _, let insertions, _):
                for index in insertions {
                    if let addedTask = self.realm?.object(ofType: TaskRealmObject.self, forPrimaryKey: tasks[index].id) {
                        let date = addedTask.dueDate
                        presenter?.didSelectDate(with: date)
                    }
                }
                break
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
}
