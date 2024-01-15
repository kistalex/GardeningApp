//
// GardeningApp
// PlantsTasksRouter.swift
//
// Created by Alexander Kist on 22.12.2023.
//

import UIKit

protocol PlantsTasksRouterProtocol {
    func openAddTaskVC()
}

class PlantsTasksRouter: PlantsTasksRouterProtocol {
    weak var viewController: PlantsTasksViewController?


    func openAddTaskVC() {
        let vc = AddPlantTaskModuleBuilder.build()
        let navController = UINavigationController(rootViewController: vc)
        viewController?.present(navController, animated: true)
    }
}
