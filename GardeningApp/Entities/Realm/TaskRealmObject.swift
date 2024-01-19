//
//
// GardeningApp
// TaskRealmObject.swift
// 
// Created by Alexander Kist on 24.01.2024.
//


import Foundation
import RealmSwift

class TaskRealmObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var taskType: String
    @Persisted var dueDate: Date
    @Persisted var taskDescription: String? = nil
    @Persisted var isComplete: Bool = false
    @Persisted(originProperty: "tasks") var plant: LinkingObjects<PlantObject>

    convenience init(taskType: String, dueDate: Date, taskDescription: String? = nil, isComplete: Bool = false) {
        self.init()
        self.taskType = taskType
        self.dueDate = dueDate
        self.taskDescription = taskDescription
        self.isComplete = isComplete
    }
}
