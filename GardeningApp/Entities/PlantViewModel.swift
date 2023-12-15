//
//
// GardeningApp
// PlantViewModel.swift
// 
// Created by Alexander Kist on 12.12.2023.
//


import Foundation
import UIKit

struct PlantViewModel {
    let image: UIImage?
    let name: String
    let age: String
    let description: String?

    init(entity: PlantObject) {
        self.image = entity.image
        self.name = entity.plantName
        self.age = entity.plantAge
        self.description = entity.plantDescription
    }
}
