//
// GardeningApp
// HomeRouter.swift
//
// Created by Alexander Kist on 10.12.2023.
//

protocol HomeRouterProtocol {
    func openNewPlantVC()
}

class HomeRouter {
    weak var viewController: HomeViewController?
}

extension HomeRouter: HomeRouterProtocol {
    func openNewPlantVC() {
        let vc = NewPlantModuleBuilder.build()
        viewController?.present(vc, animated: true)
    }
}
/*
 if let sheet = addExpense.sheetPresentationController {
     sheet.detents = [.medium()]
     sheet.prefersGrabberVisible = true
 }
 */
