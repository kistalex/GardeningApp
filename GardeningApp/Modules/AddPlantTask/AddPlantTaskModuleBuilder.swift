//
// GardeningApp
// AddPlantTaskModuleBuilder.swift
//
// Created by Alexander Kist on 05.01.2024.

import UIKit

class AddPlantTaskModuleBuilder {
    static func build() -> AddPlantTaskViewController {
        let interactor = AddPlantTaskInteractor()
        let router = AddPlantTaskRouter()
        let presenter = AddPlantTaskPresenter(interactor: interactor, router: router)
        let viewController = AddPlantTaskViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
