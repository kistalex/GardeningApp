//
// GardeningApp
// TasksModuleBuilder.swift
//
// Created by Alexander Kist on 15.01.2024.

import UIKit

class TasksModuleBuilder {
    static func build() -> TasksViewController {
        let realmManager = RealmManager<TaskRealmObject>()
        let interactor = TasksInteractor(realmManager: realmManager)
        let router = TasksRouter()
        let presenter = TasksPresenter(interactor: interactor, router: router)
        let viewController = TasksViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
