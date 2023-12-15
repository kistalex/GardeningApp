//
// GardeningApp
// NewPlantRouter.swift
//
// Created by Alexander Kist on 12.12.2023.
//

import PhotosUI
protocol NewPlantRouterProtocol {
    func presentImagePicker(withConfig config: PHPickerConfiguration)
    func dismissViewController()
}

class NewPlantRouter: NewPlantRouterProtocol {
    weak var viewController: NewPlantViewController?

    func presentImagePicker(withConfig config: PHPickerConfiguration) {
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = viewController
        viewController?.present(imagePicker, animated: true)
    }
    
    func dismissViewController(){
        viewController?.dismiss(animated: true)
    }
}

