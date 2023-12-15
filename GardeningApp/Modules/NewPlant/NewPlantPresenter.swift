//
// GardeningApp
// NewPlantPresenter.swift
//
// Created by Alexander Kist on 12.12.2023.
//
import PhotosUI
import UIKit
protocol NewPlantPresenterProtocol: AnyObject {
    func didTapOpenImagePicker()
    func didFinishPickingImage(results: [PHPickerResult])
    func didTapSavePlant(image: UIImage?, name: String, age: String, description: String?)
}

class NewPlantPresenter {
    weak var view: NewPlantViewProtocol?
    var router: NewPlantRouterProtocol
    var interactor: NewPlantInteractorProtocol

    init(interactor: NewPlantInteractorProtocol, router: NewPlantRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension NewPlantPresenter: NewPlantPresenterProtocol {

    func didTapOpenImagePicker() {
        let config = interactor.createPickerConfiguration()
        router.presentImagePicker(withConfig: config)
    }

    func didFinishPickingImage(results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    self.view?.displayImage(image)
                } else {
                    print("Failed to load image")
                }
            }
        }
    }

    func didTapSavePlant(image: UIImage?, name: String, age: String, description: String?) {
        let plant = PlantObject(imageData: image?.jpegData(compressionQuality: 1.0), plantName: name, plantAge: age, plantDescription: description)
        interactor.savePlantObject(with: plant)
        router.dismissViewController()
    }
}
