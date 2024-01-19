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
    func savePlantObject(with plantModel: PlantModel)
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

    func savePlantObject(with plantModel: PlantModel) {
        guard let realm = realm,
              let plantName = plantModel.name,
              let plantAge = plantModel.age
        else { return }

        let plantDesc = plantModel.description?.isEmpty ?? true ? "Your observations and notes on flower care could have been here, but you didn't add them😔" : plantModel.description

        let plant = PlantObject(
            imageData: plantModel.image?.jpegData(compressionQuality: 1.0),
            plantName: plantName,
            plantAge: plantAge,
            plantDescription: plantDesc
        )

        do {
            try realm.write {
                realm.add(plant)
            }
        } catch {
            print(error)
        }
    }

    func createPickerConfiguration() -> PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        return config
    }
}
