//
//
// GardeningApp
// PlantObject.swift
//
// Created by Alexander Kist on 14.12.2023.
//


import Foundation
import RealmSwift
import UIKit


class PlantObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var imageData: Data?
    @Persisted var plantName: String = ""
    @Persisted var plantAge: Date
    @Persisted var plantDescription: String? = nil
    @Persisted var tasks = List<TaskRealmObject>()

    var image: UIImage? {
        get {
            if let imageData = self.imageData {
                return UIImage(data: imageData)
            }
            return nil
        }
        set {
            self.imageData = newValue?.jpegData(compressionQuality: 1.0)
        }
    }

    convenience init(imageData: Data?, plantName: String, plantAge: Date, plantDescription: String? = nil) {
        self.init()
        self.id = ObjectId.generate()
        self.imageData = imageData
        self.plantName = plantName
        self.plantAge = plantAge
        self.plantDescription = plantDescription
    }
}



