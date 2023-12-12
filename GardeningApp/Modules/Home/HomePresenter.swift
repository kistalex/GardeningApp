//
// GardeningApp
// HomePresenter.swift
//
// Created by Alexander Kist on 10.12.2023.
//

import UIKit

protocol HomePresenterProtocol: AnyObject {
    func fetchCurrentTimeImage()
    func fetchCurrentGreeting()
    func fetchCurrentLocationWeather()
    func currentTimeImageFetched(with image: UIImage?)
    func currentGreetingFetched(with text: String)
    func currentWeatherFetched(with weatherData: WeatherData)
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
    func fetchCurrentTimeImage() {
        interactor.fetchCurrentTimeImage()
    }

    func fetchCurrentLocationWeather() {
        interactor.fetchCurrenLocationWeather()
    }

    func fetchCurrentGreeting() {
        interactor.fetchCurrentGreetings()
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
