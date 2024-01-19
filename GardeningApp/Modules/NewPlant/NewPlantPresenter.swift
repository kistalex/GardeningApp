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
    func didTapSavePlant(for plantModel: PlantModel)

    func didFetchCells()
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

    func didFetchCells() {
        let cellModels = createCellModels()
        view?.setCells(with: cellModels)
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

    func didTapSavePlant(for plantModel: PlantModel) {
        interactor.savePlantObject(with: plantModel)
        router.dismissViewController()
    }

    private func createCellModels() -> [TableViewCellItemModel]{
        guard let placeholderImage = UIImage(named: "pickerPlaceholder") else { return [] }
        return [
            PlantImageTableViewCellModel(placeholderImage: placeholderImage),
                PlantNameTableCellModel(),
                DatePlantCaringTableViewCellModel(labelText: "Choose a date to start caring for your plant"),
                PlantDescriptionTableViewCellModel(placeholderText: "Input here", labelText: "If you want, you can add a description of your plant or some personal observations"),
                SavePlantButtonTableViewCellModel(buttonTitle: "Save")
        ]
    }
}

