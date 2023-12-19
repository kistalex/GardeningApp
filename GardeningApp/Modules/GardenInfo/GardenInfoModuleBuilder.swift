//
// GardeningApp
// GardenInfoModuleBuilder.swift
//
// Created by Alexander Kist on 15.12.2023.

import UIKit

class GardenInfoModuleBuilder {
    static func build(with plant: PlantObject) -> GardenInfoViewController {
        let interactor = GardenInfoInteractor(plant: plant)
        let router = GardenInfoRouter()
        let presenter = GardenInfoPresenter(interactor: interactor, router: router)
        let viewController = GardenInfoViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
