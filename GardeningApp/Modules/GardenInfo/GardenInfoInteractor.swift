//
// GardeningApp
// GardenInfoInteractor.swift
//
// Created by Alexander Kist on 15.12.2023.
//

protocol GardenInfoInteractorProtocol: AnyObject {
    func fetchPlantInfo()
}

class GardenInfoInteractor: GardenInfoInteractorProtocol {
    weak var presenter: GardenInfoPresenterProtocol?

    private var plant: PlantObject

    init(plant: PlantObject){
        self.plant = plant
    }

    func fetchPlantInfo() {
        presenter?.plantInfoFetched(plant: plant)
    }
}
