//
// GardeningApp
// PlantsTasksModuleBuilder.swift
//
// Created by Alexander Kist on 22.12.2023.

import UIKit

class PlantsTasksModuleBuilder {
    static func build() -> PlantsTasksViewController {
        let interactor = PlantsTasksInteractor()
        let router = PlantsTasksRouter()
        let presenter = PlantsTasksPresenter(interactor: interactor, router: router)
        let viewController = PlantsTasksViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
