//
// GardeningApp
// TasksRouter.swift
//
// Created by Alexander Kist on 15.01.2024.
//

import UIKit

protocol TasksRouterProtocol {
    func openAddTaskVC()
}

class TasksRouter: TasksRouterProtocol {
    weak var viewController: TasksViewController?
    
    func openAddTaskVC() {
        let vc = AddPlantTaskModuleBuilder.build()
        let navController = UINavigationController(rootViewController: vc)
        viewController?.present(navController, animated: true)
    }
}
