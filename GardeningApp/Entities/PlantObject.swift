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
    @Persisted var plantAge: String = ""
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

    convenience init(imageData: Data?, plantName: String, plantAge: String, plantDescription: String? = nil) {
        self.init()
        self.id = ObjectId.generate()
        self.imageData = imageData
        self.plantName = plantName
        self.plantAge = plantAge
        self.plantDescription = plantDescription
    }
}


class TaskRealmObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var taskType: String
    @Persisted var dueDate: Date
    @Persisted var taskDescription: String? = nil
    
    @Persisted(originProperty: "tasks") var plant: LinkingObjects<PlantObject>

    convenience init(taskType: String, dueDate: Date, taskDescription: String? = nil) {
        self.init()
        self.taskType = taskType
        self.dueDate = dueDate
        self.taskDescription = taskDescription
    }
}
