//
// GardeningApp
// HomePresenter.swift
//
// Created by Alexander Kist on 10.12.2023.
//

import UIKit
import RealmSwift

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func currentWeatherFetched(with weatherData: WeatherModel)
    func plantsFetched(with plants: [PlantObject])
    func didTapAddNewPlant()
    func didTapTaskManagerButton()
    func didTapOpenGardenInfo(with plant: PlantViewModel)
    func didFetchInitialData(with data: HomeTableViewData)
}

class HomePresenter {
    weak var view: HomeViewProtocol?
    var router: HomeRouterProtocol
    var interactor: HomeInteractorProtocol

    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension HomePresenter: HomePresenterProtocol {

    private enum Constants{
        static let celsiusSign = " °C"
        static let percentSign = " %"
        static let speedSign = " m/s"
        static let nilSign = "-/-"
        static let searchIconName = "magnifyingglass"
        static let notifyIconName = "bell"
        static let imagePointSize: CGFloat = 18
        static let introductionText = "Flora is Here, your personal garden manager!"
        static let headerText = "My Garden"
        static let buttonImageName = "plus.circle.fill"
        static let buttonTitle = "Add new plant"
        static let placeholderImage = "pickerPlaceholder"
        static let dateFormat = "MMMM dd, yyyy"
    }

    func viewDidLoad() {
        interactor.fetchInitialData()
        interactor.fetchCurrenLocationWeather()
    }

    func didFetchInitialData(with data: HomeTableViewData){
        let tableData = configureFetchedData(from: data)
        let cellModels = setupCells(with: tableData)
        view?.setCells(cellModels)
    }

    private func setupCells(with data: HomeTableViewModel) -> [TableViewCellItemModel] {
        let initialWeatherData = WeatherViewModel(temp: Constants.nilSign, humidity: Constants.nilSign, windSpeed: Constants.nilSign)
        return [
            ButtonsTableViewCellModel(
                searchIconName: Constants.searchIconName,
                notifyIconName: Constants.notifyIconName,
                imagePointSize: Constants.imagePointSize),
            GreetingsTableViewCellModel(
                greetingText: data.greeting,
                introductionText: Constants.introductionText),
            ImageTableViewCellModel(image: data.image),
            WeatherInfoTableViewCellModel(weatherData: initialWeatherData),
            GardenHeaderTableViewCellModel(
                headerText: Constants.headerText,
                buttonImageName: Constants.buttonImageName,
                buttonTitle: Constants.buttonTitle),
            UserPlantCollectionTableViewCellModel(plants: data.userPlants)
        ]
    }

    func didTapAddNewPlant() {
        router.openNewPlantVC()
    }

    func didTapOpenGardenInfo(with plant: PlantViewModel) {
        router.openGardenInfoVC(with: plant)
    }

    func didTapTaskManagerButton() {
        router.openPlantsTasksVC()
    }

    func plantsFetched(with plants: [PlantObject]) {
        let plantsModels = getPlantsModels(plants: plants)
        view?.setPlants(with: plantsModels)
    }

    func currentWeatherFetched(with weatherData: WeatherModel) {
        let weatherDataModel = getWeatherDataModel(from: weatherData)
        view?.showCurrentWeatherData(with: weatherDataModel)
    }

    private func getWeatherDataModel(from weatherData: WeatherModel) -> WeatherViewModel {
        return WeatherViewModel(
            temp: "\(weatherData.current.temp)" + Constants.celsiusSign,
            humidity: "\(weatherData.current.humidity)" + Constants.percentSign,
            windSpeed: "\(weatherData.current.windSpeed)" + Constants.speedSign
        )
    }

    private func configureFetchedData(from data: HomeTableViewData) -> HomeTableViewModel {
        let homeViewModel = HomeTableViewModel(greeting: data.greeting, image: data.image, userPlants: getPlantsModels(plants: data.userPlants))
        return homeViewModel
    }

    private func getPlantsModels(plants: [PlantObject]) -> [PlantViewModel]{
        return plants.map { plant in
            let age = convertDateToString(date: plant.plantAge)
            let image = plant.image ?? UIImage(named: Constants.placeholderImage)
            return PlantViewModel(
                image: image,
                name: plant.plantName,
                age: age,
                description: plant.plantDescription
            )
        }
    }

    private func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        return formatter.string(from: date)
    }
}
