//
// GardeningApp
// HomeInteractor.swift
//
// Created by Alexander Kist on 10.12.2023.
//

import CoreLocation
import WeatherKit

protocol HomeInteractorProtocol: AnyObject {
    func fetchCurrentTimeImage()
    func fetchCurrentGreetings()
    func fetchCurrenLocationWeather()
}

class HomeInteractor: NSObject, HomeInteractorProtocol, CLLocationManagerDelegate {

    weak var presenter: HomePresenterProtocol?

    private let imageProvider: ImageProvider
    private let greetingProvider: GreetingProvider

    private let weatherManager: WeatherApiManager
    private let locationManager: CLLocationManager


    init(imageProvider: ImageProvider,greetingProvider: GreetingProvider, locationManager: CLLocationManager, weatherManager: WeatherApiManager) {
        self.imageProvider = imageProvider
        self.greetingProvider = greetingProvider
        self.locationManager = locationManager
        self.weatherManager = weatherManager
        super.init()
    }

    func fetchCurrentTimeImage() {
        let image = imageProvider.imageForCurrentTime()
        presenter?.currentTimeImageFetched(with: image)
    }

    func fetchCurrentGreetings() {
        let greeting = greetingProvider.greetingForCurrentTime()
        presenter?.currentGreetingFetched(with: greeting )
    }


    func fetchCurrenLocationWeather() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    private func getCurrentWeather(location: CLLocation){
        let weatherApiManager = WeatherApiManager()
        weatherApiManager.fetchCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.latitude) { result in
            switch result {
            case .success(let weatherData):
                self.presenter?.currentWeatherFetched(with: weatherData)
            case .failure(let error):
                print(error)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        getCurrentWeather(location: location)
    }
}
