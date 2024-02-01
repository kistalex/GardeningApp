//
// GardeningApp
// AddPlantTaskInteractor.swift
//
// Created by Alexander Kist on 05.01.2024.
//

import RealmSwift

protocol AddPlantTaskInteractorProtocol: AnyObject {
    func fetchCellData()
    func saveTaskData(with data: TaskModel, completion: @escaping (Result<Void, Error>) -> Void)
}

class AddPlantTaskInteractor: AddPlantTaskInteractorProtocol {
    weak var presenter: AddPlantTaskPresenterProtocol?
    
    private let realm: Realm?

    init() {
        do {
            realm = try Realm()
        } catch let error {
            print("Failed to instantiate Realm: \(error.localizedDescription)")
            realm = nil
        }
    }

    private enum Constants {
        static let emptyDescriptionText = "No description"
        static let plantNameField = "Plant name "
        static let dueDateField = "Due date "
        static let taskTypesField = "Task types "
        static let textSeparator = "\n"
        static let message = "Please fill in the following fields:"
    }

    private enum TaskSaveError: Error {
        case missingFields(fields: [String])
        case invalidObjectId
        case realmWriteError(error: Error)
        case plantNotFound
    }

    private enum TaskType: String, CaseIterable {
        case watering = "Watering"
        case lighting = "Lighting"
        case temperatureControl = "Temperature Control"
        case feeding = "Feeding"
        case pruning = "Pruning"
        case repotting = "Repotting"
        case pestControl = "Pest Control"
        case soilAeration = "Soil Aeration"

        static func allValues() -> [String] {
            return TaskType.allCases.map { $0.rawValue }
        }
    }

    func fetchCellData() {
        let (plantIds, plantsNames) = fetchPlantIdsAndNames()
        let taskTypes = fetchTaskTypes()
        let data = AddTaskTableViewModel(taskTypes: taskTypes, plantsName: plantsNames, plantIds: plantIds)
        presenter?.didFetchData(data)
    }

    func saveTaskData(with data: TaskModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let realm = realm,
              let plantID = data.plantID,
              let taskType = data.taskType,
              let dueDate = data.dueDate
        else {
            informUserAboutMissingFields(data: data)
            return
        }

        let description = data.taskDescription?.isEmpty ?? true ? Constants.emptyDescriptionText : data.taskDescription

        guard let objectID = try? ObjectId(string: plantID) else {
            completion(.failure(TaskSaveError.invalidObjectId))
            return
        }

        do {
            try realm.write {
                if let plant = realm.object(ofType: PlantObject.self, forPrimaryKey: objectID) {
                    let task = TaskRealmObject(taskType: taskType, dueDate: dueDate, taskDescription: description)
                    plant.tasks.append(task)
                    completion(.success(()))
                } else {
                    completion(.failure(TaskSaveError.plantNotFound))
                }
            }
        } catch let error {
            completion(.failure(TaskSaveError.realmWriteError(error: error)))
        }
    }

    private func informUserAboutMissingFields(data: TaskModel) {
        var missingFields = [String]()

        if data.plantID == nil {
            missingFields.append(Constants.plantNameField)
        }

        if data.dueDate == nil {
            missingFields.append(Constants.dueDateField)
        }

        if data.taskType == nil {
            missingFields.append(Constants.taskTypesField)
        }

        let missingFieldsString = missingFields.joined(separator: Constants.textSeparator)
        let message = Constants.message + Constants.textSeparator + "\(missingFieldsString)"

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
        return TaskType.allValues()
    }
}
