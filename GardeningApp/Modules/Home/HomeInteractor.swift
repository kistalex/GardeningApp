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
    
    private let realm: Realm?
    private var notificationToken: NotificationToken?

    init(imageProvider: ImageProvider,greetingProvider: GreetingProvider, locationManager: CLLocationManager, weatherManager: WeatherApiManager) {
        self.imageProvider = imageProvider
        self.greetingProvider = greetingProvider
        self.locationManager = locationManager
        self.weatherManager = weatherManager
        
        do {
            realm = try Realm()
        } catch let error {
            print("Failed to instantiate Realm: \(error.localizedDescription)")
            realm = nil
        }
        super.init()
        setupPlantChangeNotifications()
    }

    func fetchInitialData(){
        let greeting = fetchCurrentGreetings()
        let currentImage = fetchCurrentTimeImage()
        let userPlants = fetchUserPlants()
        let data = HomeTableViewData(greeting: greeting, image: currentImage, userPlants: userPlants)
        presenter?.didFetchInitialData(with: data)
    }



    deinit {
        notificationToken?.invalidate()
    }

    func setupPlantChangeNotifications() {
        let plants = realm?.objects(PlantObject.self)
        notificationToken = plants?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let plants):
                self?.presenter?.plantsFetched(with: Array(plants))
            case .update(let plants, _, _, _):
                self?.presenter?.plantsFetched(with: Array(plants))
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }


    private func fetchCurrentTimeImage() -> UIImage {
        let image = imageProvider.imageForCurrentTime()
        return image
    }

    private func fetchCurrentGreetings() -> String {
        let greeting = greetingProvider.greetingForCurrentTime()
        return greeting
    }

    private func fetchUserPlants() -> [PlantObject]{
        let plantsObjects = realm?.objects(PlantObject.self)
        guard let plants = plantsObjects else { return [] }
        return Array(plants)
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
