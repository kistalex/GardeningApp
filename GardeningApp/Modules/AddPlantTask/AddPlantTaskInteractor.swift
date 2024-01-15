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
        let plantsNames = fetchPlantNames()
        let taskTypes = fetchTaskTypes()
        let data = TableViewModel(taskTypes: taskTypes, plantsName: plantsNames)
        presenter?.didFetchData(data)
    }

    func saveTaskData(with data: TaskModel) {
        guard let realm = realm, let plantName = data.plantName else { return }
        let description = data.taskDescription?.isEmpty ?? true ?  "No description" : data.taskDescription
        guard let taskType = data.taskType, let dueDate = data.dueDate else { return }
        try? realm.write {
            if let plantID = realm.objects(PlantObject.self).filter("plantName == %@", plantName).first?.id {
                if let plant = realm.object(ofType: PlantObject.self, forPrimaryKey: plantID) {
                    let task = TaskRealmObject(taskType: taskType, dueDate: dueDate, taskDescription: description)
                    plant.tasks.append(task)
                }
            }
        }
    }


    func fetchPlantNames() -> [String] {
        guard let realm = realm else {
            return []
        }
        let plants = realm.objects(PlantObject.self)
        let plantsName = plants.map { $0.plantName}
        return Array(plantsName)
    }

    private func fetchPlantNamesWithIDs() -> [String: ObjectId] {
        guard let realm = realm else {
            return [:]
        }
        let plants = realm.objects(PlantObject.self)
        let plantNameIDMap = plants.reduce(into: [:]) { (result, plant) in
            result[plant.plantName] = plant.id
        }
        return plantNameIDMap
    }

    private func fetchTaskTypes() -> [String]{
        let taskTypes = ["Watering","Lighting","Temperature Control","Feeding","Pruning","Repotting","Pest Control","Soil Aeration"]
        return taskTypes
    }
}
