//
// GardeningApp
// AddPlantTaskInteractor.swift
//
// Created by Alexander Kist on 05.01.2024.
//

import RealmSwift

protocol AddPlantTaskInteractorProtocol: AnyObject {
    func fetchCellData()
    func saveTaskData(with data: TaskModel)
}

class AddPlantTaskInteractor: AddPlantTaskInteractorProtocol {
    weak var presenter: AddPlantTaskPresenterProtocol?
    
    private let realm: Realm?
    private var items = [TableViewCellItemModel]()

    init() {
        do {
            realm = try Realm()
        } catch let error {
            print("Failed to instantiate Realm: \(error.localizedDescription)")
            realm = nil
        }
    }

    func fetchCellData() {
        let (plantIds, plantsNames) = fetchPlantIdsAndNames()
        let taskTypes = fetchTaskTypes()
        let data = AddTaskTableViewModel(taskTypes: taskTypes, plantsName: plantsNames, plantIds: plantIds)
        presenter?.didFetchData(data)
    }

    func saveTaskData(with data: TaskModel) {
        guard let realm = realm,
              let plantID = data.plantID,
              let taskType = data.taskType,
              let dueDate = data.dueDate
        else {
            informUserAboutMissingFields(data: data)
            return
        }

        let description = data.taskDescription?.isEmpty ?? true ?  "No description" : data.taskDescription

        guard let objectID = try? ObjectId(string: plantID) else { return }


        try? realm.write {
            if let plant = realm.object(ofType: PlantObject.self, forPrimaryKey: objectID) {
                let task = TaskRealmObject(taskType: taskType, dueDate: dueDate, taskDescription: description)
                plant.tasks.append(task)
            }
        }
    }

    private func informUserAboutMissingFields(data: TaskModel) {
        var missingFields = [String]()

        if data.plantID == nil {
            missingFields.append("Plant name")
        }

        if data.dueDate == nil {
            missingFields.append("Due date")
        }

        if data.taskType == nil {
            missingFields.append("Task type")
        }

        let missingFieldsString = missingFields.joined(separator: "\n")
        let message = "Please fill in the following fields:\n\(missingFieldsString)"

        presenter?.informUserAboutFields(with: message)
    }


    func fetchPlantIdsAndNames() -> (ids: [String], names: [String]) {
        guard let realm = realm else {
            return ([], [])
        }
        let plants = realm.objects(PlantObject.self)
        let plantsNames = plants.map { $0.plantName }
        let plantIds = plants.map { $0.id.stringValue }
        return (ids: Array(plantIds), names: Array(plantsNames))
    }

    private func fetchTaskTypes() -> [String]{
        let taskTypes = ["Watering","Lighting","Temperature Control","Feeding","Pruning","Repotting","Pest Control","Soil Aeration"]
        return taskTypes
    }
}
