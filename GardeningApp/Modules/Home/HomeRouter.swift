//
// GardeningApp
// HomeRouter.swift
//
// Created by Alexander Kist on 10.12.2023.
//

protocol HomeRouterProtocol {
    func openNewPlantVC()
    func openGardenInfoVC(with plant: PlantViewModel)
    func openPlantsTasksVC()
}

class HomeRouter {
    weak var viewController: HomeViewController?
}

extension HomeRouter: HomeRouterProtocol {
    func openNewPlantVC() {
        let vc = NewPlantModuleBuilder.build()
        viewController?.present(vc, animated: true)
    }

    func openGardenInfoVC(with plant: PlantViewModel) {
        let vc = GardenInfoModuleBuilder.build(with: plant)
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        viewController?.present(vc, animated: true)
    }

    func openPlantsTasksVC() {
        let vc = TasksModuleBuilder.build()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

