//
// GardeningApp
// GardenInfoPresenter.swift
//
// Created by Alexander Kist on 15.12.2023.
//

protocol GardenInfoPresenterProtocol: AnyObject {
    func plantInfoFetched(plant: PlantObject)
    func viewDidLoad()
}

class GardenInfoPresenter {
    weak var view: GardenInfoViewProtocol?
    var router: GardenInfoRouterProtocol
    var interactor: GardenInfoInteractorProtocol

    init(interactor: GardenInfoInteractorProtocol, router: GardenInfoRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension GardenInfoPresenter: GardenInfoPresenterProtocol {
    func plantInfoFetched(plant: PlantObject) {
        view?.showPlantInfo(plant: plant)
    }
    func viewDidLoad() {
        interactor.fetchPlantInfo()
    }
}
