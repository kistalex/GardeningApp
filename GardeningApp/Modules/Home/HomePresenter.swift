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
    func currentTimeImageFetched(with image: UIImage?)
    func currentGreetingFetched(with text: String)
    func currentWeatherFetched(with weatherData: WeatherData)
    func plantsFetched(with plants: [PlantObject])
    func didTapAddNewPlant()
//    func setPlants()
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

    func viewDidLoad() {
        interactor.fetchCurrentGreetings()
        interactor.fetchCurrentTimeImage()
        interactor.fetchUserPlants()
    }

    func didTapAddNewPlant() {
        router.openNewPlantVC()
    }

//    func setPlants() {
//        let plants = interactor.fetchPlants()
//        view?.setPlants(with: plants)
//    }
    
    func plantsFetched(with plants: [PlantObject]) {
        view?.setPlants(with: plants)
    }

    func currentGreetingFetched(with text: String) {
        view?.showGreetingForCurrentTime(text: text)
    }

    func currentTimeImageFetched(with image: UIImage?) {
        view?.showImageForCurrentTime(image: image)
    }

    func currentWeatherFetched(with weatherData: WeatherData) {
        view?.showCurrentWeatherData(with: weatherData)
    }
}
