//
// GardeningApp
// PlantsTasksPresenter.swift
//
// Created by Alexander Kist on 22.12.2023.
//

import UIKit

protocol PlantsTasksPresenterProtocol: AnyObject {
    func didSelectDate(_ date: Date)
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
    func didSelectDate(_ date: Date) {
        let localDateString = formatDate(date, timeZone: TimeZone.current)
        let utcDateString = formatDate(date, timeZone: TimeZone(secondsFromGMT: 0)!)

        print("Presenter didSelectDate (Local): \(localDateString)")
        print("Presenter didSelectDate (UTC): \(utcDateString)")

        view?.setDateLabel(with: date)
    }

    private func formatDate(_ date: Date, timeZone: TimeZone) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            dateFormatter.timeZone = timeZone

            return dateFormatter.string(from: date)
        }
}
