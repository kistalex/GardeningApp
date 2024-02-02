//
//
// GardeningApp
// RealmManager.swift
//
// Created by Alexander Kist on 01.02.2024.
//


import Foundation
import RealmSwift

protocol RealmManagerProtocol {
    associatedtype ObjectType: Object
    func fetchObjects() -> [ObjectType]
    func setupChangeNotifications(
        onInitial: (([ObjectType]) -> Void)?,
        onUpdate: (([ObjectType], RealmCollectionChange<Any>) -> Void)?
    ) -> NotificationToken?
    func updateTaskStatus(taskId: String, completion: @escaping (Result<TaskRealmObject, Error>) -> Void)
}

final class RealmManager<ObjectType: Object>: RealmManagerProtocol {

    private var realm: Realm?

    enum TaskUpdateError: Error {
        case initializationError
        case objectNotFound
    }

    init() {
        do {
            realm = try Realm()
        } catch let error {
            print("Failed to instantiate Realm: \(error.localizedDescription)")
        }
    }

    func fetchObjects() -> [ObjectType] {
        guard let realm = realm else { return []}
        let objects = realm.objects(ObjectType.self)
        return Array(objects)
    }

    func fetchObjects(for date: Date, with predicate: String) -> [ObjectType] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: startOfDay) ?? date
        }()

        guard let realm = realm else { return [] }
        let predicate = NSPredicate(format: predicate, argumentArray: [startOfDay, endOfDay])
        let objects = realm.objects(ObjectType.self).filter(predicate)
        return Array(objects)
    }

    func setupChangeNotifications(
        onInitial: (([ObjectType]) -> Void)? = nil,
        onUpdate: (([ObjectType], RealmCollectionChange<Any>) -> Void)? = nil
    ) -> NotificationToken? {
        guard let objects = realm?.objects(ObjectType.self) else {
            print("Realm is not initialized or the objects type does not exist in Realm")
            return nil
        }

        let token = objects.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let results):
                onInitial?(Array(results))
            case .update(let results, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                onUpdate?(Array(results), .update(results, deletions: deletions, insertions: insertions, modifications: modifications))
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        return token
    }

    func updateTaskStatus(taskId: String, completion: @escaping (Result<TaskRealmObject, Error>) -> Void) {
        guard let realm = realm else {
            completion(.failure(TaskUpdateError.initializationError))
            return
        }

        guard let objectID = try? ObjectId(string: taskId),
              let task = realm.object(ofType: TaskRealmObject.self, forPrimaryKey: objectID) else {
            completion(.failure(TaskUpdateError.objectNotFound))
            return
        }

        do {
            try realm.write {
                task.isComplete.toggle()
                completion(.success(task))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
