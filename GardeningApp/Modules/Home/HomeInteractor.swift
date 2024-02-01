//
// GardeningApp
// HomeInteractor.swift
//
// Created by Alexander Kist on 10.12.2023.
//

import CoreLocation
import RealmSwift
import UIKit

protocol HomeInteractorProtocol: AnyObject {
    func fetchCurrenLocationWeather()
    func fetchInitialData()
}

class HomeInteractor: NSObject, HomeInteractorProtocol, CLLocationManagerDelegate {

    weak var presenter: HomePresenterProtocol?

    private let imageProvider: ImageProvider
    private let greetingProvider: GreetingProvider

    private let weatherManager: WeatherApiManager
    private let locationManager: CLLocationManager
    private let realmManager: RealmManager<PlantObject>

    private var notificationToken: NotificationToken?

    init(imageProvider: ImageProvider,
         greetingProvider: GreetingProvider,
         locationManager: CLLocationManager,
         weatherManager: WeatherApiManager,
         realmManager: RealmManager<PlantObject>
    ) {
        self.imageProvider = imageProvider
        self.greetingProvider = greetingProvider
        self.locationManager = locationManager
        self.weatherManager = weatherManager
        self.realmManager = realmManager
        super.init()
        setupPlantChangeNotifications()
    }

    func fetchInitialData(){
        let greeting = greetingProvider.greetingForCurrentTime()
        let currentImage = imageProvider.imageForCurrentTime()
        let userPlants = realmManager.fetchObjects()
        let data = HomeTableViewData(greeting: greeting, image: currentImage, userPlants: userPlants)
        presenter?.didFetchInitialData(with: data)
    }

    deinit {
        notificationToken?.invalidate()
    }

    func setupPlantChangeNotifications() {
        notificationToken = realmManager.setupChangeNotifications(
            onInitial: { [weak self] plants in
            self?.presenter?.plantsFetched(with: plants)
        }, onUpdate: { [weak self] plants, _ in
            self?.presenter?.plantsFetched(with: plants)
        })
    }

    func fetchCurrenLocationWeather() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func getCurrentWeather(location: CLLocation) {
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
