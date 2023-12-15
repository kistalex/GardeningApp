//
// GardeningApp
// NewPlantModuleBuilder.swift
//
// Created by Alexander Kist on 12.12.2023.

import UIKit

class NewPlantModuleBuilder {
    static func build() -> NewPlantViewController {
        let interactor = NewPlantInteractor()
        let router = NewPlantRouter()
        let presenter = NewPlantPresenter(interactor: interactor, router: router)
        let viewController = NewPlantViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
