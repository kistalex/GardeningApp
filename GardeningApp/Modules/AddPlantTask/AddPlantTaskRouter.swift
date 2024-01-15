//
// GardeningApp
// AddPlantTaskRouter.swift
//
// Created by Alexander Kist on 05.01.2024.
//

protocol AddPlantTaskRouterProtocol {
    func dismissViewController()
}

class AddPlantTaskRouter: AddPlantTaskRouterProtocol {
    weak var viewController: AddPlantTaskViewController?


    func dismissViewController(){
        viewController?.dismiss(animated: true)
    }
}
