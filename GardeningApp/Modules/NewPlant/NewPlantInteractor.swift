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
    func savePlantObject(image: UIImage?, name: String, age: String, description: String?)
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

    func savePlantObject(image: UIImage?, name: String, age: String, description: String?) {
        let userDescription = description?.isEmpty ?? true ?  "Your observations and notes on flower care could have been here, but you didn't add them😔" : description

        let plant = PlantObject(imageData: image?.jpegData(compressionQuality: 1.0), plantName: name, plantAge: age, plantDescription: userDescription)

        do {
            try realm?.write({
                realm?.add(plant)
            })
        } catch {
            print(error)
        }
    }
}
