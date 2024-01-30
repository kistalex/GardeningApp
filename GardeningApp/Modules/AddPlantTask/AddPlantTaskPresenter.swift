//
// GardeningApp
// AddPlantTaskPresenter.swift
//
// Created by Alexander Kist on 05.01.2024.
//

import Foundation

protocol AddPlantTaskPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didFetchData(_ data: AddTaskTableViewModel)
    func saveTaskData(with data: TaskModel)
    func dismissVC()
    func informUserAboutFields(with message: String)
}

class AddPlantTaskPresenter {
    weak var view: AddPlantTaskViewProtocol?
    var router: AddPlantTaskRouterProtocol
    var interactor: AddPlantTaskInteractorProtocol

    init(interactor: AddPlantTaskInteractorProtocol, router: AddPlantTaskRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension AddPlantTaskPresenter: AddPlantTaskPresenterProtocol {

    func viewDidLoad() {
        interactor.fetchCellData()
    }

    func saveTaskData(with data: TaskModel) {
        interactor.saveTaskData(with: data) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.view?.dismissVC()
                case .failure(let error):
                    self?.view?.showError(with: error.localizedDescription)
                }
            }
        }
    }

    func didFetchData(_ data: AddTaskTableViewModel) {
        let cellModels = createCellModels(from: data)
        view?.setCells(with: cellModels)
    }

    func informUserAboutFields(with message: String) {
        view?.showError(with: message)
    }

    private enum Constants{
        static let plantNameCollectionLabelText = "Select the plant name"
        static let dueDatePickerLabelText = "Select the date of completion"
        static let taskTypesCollectionLabelText = "Select the type of task"
        static let textViewPlaceholderText = "Add an explanation, description or nuance of the process"
        static let saveTaskButtonText = "Save"
    }

    private func createCellModels(from data: AddTaskTableViewModel) -> [TableViewCellItemModel]{
        return [
            PlantsNamesCollectionTableViewCellModel(plantIDs: data.plantIds, plantsNames: data.plantsName, labelText: Constants.plantNameCollectionLabelText),
            DueDatePickerTableViewCellModel(labelText: Constants.dueDatePickerLabelText),
            TaskTypesCollectionTableViewCellModel(taskTypes: data.taskTypes, labelText: Constants.taskTypesCollectionLabelText),
            TextViewTableViewCellModel(placeholderText: Constants.textViewPlaceholderText),
            SaveTaskButtonTableViewCellModel(title: Constants.saveTaskButtonText)
        ]
    }

    func dismissVC() {
        router.dismissViewController()
    }
}

