//
// GardeningApp
// PlantsTasksInteractor.swift
//
// Created by Alexander Kist on 22.12.2023.
//

import Foundation
import RealmSwift

protocol PlantsTasksInteractorProtocol: AnyObject {
    func fetchDates()
    func fetchCurrentDate()
    func fetchPlantsTasks()
}

class PlantsTasksInteractor: PlantsTasksInteractorProtocol {
    weak var presenter: PlantsTasksPresenterProtocol?

    private var realm: Realm?
    private var notificationToken: NotificationToken?


    init() {
        do {
            realm = try Realm()
        } catch let error {
            print("Failed to instantiate Realm: \(error.localizedDescription)")
            realm = nil
        }
//        setupTaskChangeNotifications()
    }

    deinit {
        notificationToken?.invalidate()
    }


    private func setupTaskChangeNotifications() {
        guard let realm = realm else { return }
        let tasks = realm.objects(TaskRealmObject.self)
        notificationToken = tasks.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let tasks):
                print("Готовые таски: \(tasks)")
                self?.presenter?.plantsTasksFetched(tasks: Array(tasks))
            case .update(let tasks, _, _, _):
                self?.presenter?.plantsTasksFetched(tasks: Array(tasks))
                print("Обновленные таски: \(tasks)")
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchPlantsTasks(){
        let plantsTasks = realm?.objects(TaskRealmObject.self)
        guard let tasks = plantsTasks else { return }
        presenter?.plantsTasksFetched(tasks: Array(tasks))
    }



    func fetchDates()  {
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
                presenter?.datesFetched(dates: dates)
            }
        }
    }

    func fetchCurrentDate(){
        let selectedDate = Date()
        presenter?.setCurrentDate(date: selectedDate)
    }
}
