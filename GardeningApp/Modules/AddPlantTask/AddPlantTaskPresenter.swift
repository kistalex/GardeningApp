//
// GardeningApp
// AddPlantTaskPresenter.swift
//
// Created by Alexander Kist on 05.01.2024.
//

protocol AddPlantTaskPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didFetchData(_ data: TableViewModel)
    func saveTaskData(with data: TaskModel)
    func dismissVC()
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
        interactor.saveTaskData(with: data)
    }

    func didFetchData(_ data: TableViewModel) {
        let cellModels = createCellModels(from: data)
        view?.setCells(with: cellModels)
    }

    private func createCellModels(from data: TableViewModel) -> [TableViewCellItemModel]{
        return [
            PlantsNamesCollectionTableViewCellModel(plantsNames: data.plantsName, labelText: "Select the plant name"),
            DatePickerTableViewCellModel(labelText: "Select the date of completion"),
            TaskTypesCollectionTableViewCellModel(taskTypes: data.taskTypes, labelText: "Select the type of task"),
            TextViewTableViewCellModel(placeholderText: "Add an explanation, description or nuance of the process"),
            SaveTaskButtonTableViewCellModel(title: "Сохранить")
        ]
    }

    func dismissVC() {
        router.dismissViewController()
    }
}
//Select the plant name
//Select the date of completion
//Select the type of task
//Add an explanation, description or nuance of the process
//Save
