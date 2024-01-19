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

    private var plant: PlantViewModel

    init(plant: PlantViewModel){
        self.plant = plant
    }

    func fetchPlantInfo() {
        presenter?.plantInfoFetched(plant: plant)
    }
}
