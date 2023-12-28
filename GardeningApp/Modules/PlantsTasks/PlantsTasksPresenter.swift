//
// GardeningApp
// PlantsTasksPresenter.swift
//
// Created by Alexander Kist on 22.12.2023.
//

import UIKit

protocol PlantsTasksPresenterProtocol: AnyObject {
    func datesFetched(dates: [Date])
    func viewDidLoad()
    func setCurrentDate(date: Date)
    func didSelectDate(date: Date?)
    func todayButtonTapped()
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
    }

    func datesFetched(dates: [Date]) {
        view?.setDates(dates: dates)
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
}
