//
// GardeningApp
// NewPlantInteractor.swift
//
// Created by Alexander Kist on 12.12.2023.
//

import PhotosUI
import RealmSwift

protocol NewPlantInteractorProtocol: AnyObject {
    func createPickerConfiguration() -> PHPickerConfiguration
    func savePlantObject(with plant: PlantObject)
}

class NewPlantInteractor: NewPlantInteractorProtocol {

    weak var presenter: NewPlantPresenterProtocol?

    private let realm: Realm?

    init(){
        do {
            realm = try Realm()
        } catch let error {
            print("Failed to instantiate Realm: \(error.localizedDescription)")
            realm = nil
        }
    }

    func createPickerConfiguration() -> PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        return config
    }

    func savePlantObject(with plant: PlantObject) {
        do {
            try realm?.write {
                realm?.add(plant)
            }
        } catch {
            print(error)
        }
    }
}
