//
// GardeningApp
// HomeModuleBuilder.swift
//
// Created by Alexander Kist on 10.12.2023.

import UIKit
import CoreLocation
import WeatherKit

class HomeModuleBuilder {
    static func build() -> UINavigationController {
        let imageProvider = ImageProvider()
        let locationManager = CLLocationManager()
        let weatherManager = WeatherApiManager()
        let greetingProvider = GreetingProvider()
        let interactor = HomeInteractor(imageProvider: imageProvider,greetingProvider: greetingProvider, locationManager: locationManager, weatherManager: weatherManager)
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        let viewController = HomeViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.tintColor = .dark
        navigationController.navigationBar.barTintColor = .light
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.dark]
        return navigationController
    }
}
