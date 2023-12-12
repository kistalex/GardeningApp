//
// GardeningApp
// HomeViewController.swift
//
// Created by Alexander Kist on 10.12.2023.
//

import UIKit
import SnapKit

protocol HomeViewProtocol: AnyObject {
    func showImageForCurrentTime(image: UIImage?)
    func showGreetingForCurrentTime(text: String)
    func showCurrentWeatherData(with weather: WeatherData)
}

class HomeViewController: UIViewController {
    // MARK: - Public
    var presenter: HomePresenterProtocol?


    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.tint.withAlphaComponent(0.5).cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 10.0
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 10.0
        iv.layer.masksToBounds = true
        return iv
    }()

    private let greetingLabel = CustomLabel(fontName: UIFont.title(), text: "Good evening")
    private let descriptionLabel = CustomLabel(fontName: UIFont.body(), text: "Flora is Here, your personal garden manager!")

    private let searchButton = CustomButton(imageName: "magnifyingglass", configImagePointSize: 20)

    private let notificationButton = CustomButton(imageName: "bell", configImagePointSize: 20)

    private var buttonStack = UIStackView()

    private let tempInfo = WeatherInfoView(imageName: "thermometer.medium")
    private let humidityInfo = WeatherInfoView(imageName: "humidity.fill")
    private let windInfo = WeatherInfoView(imageName: "wind")

    private let weatherInfoStack = UIStackView()



    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.fetchCurrentTimeImage()
        presenter?.fetchCurrentLocationWeather()
        presenter?.fetchCurrentGreeting()
    }
}

// MARK: - Private functions
private extension HomeViewController {
    func initialize() {
        setupViews()
    }

    private func setupViews(){
        view.backgroundColor = .background

        [searchButton, notificationButton].forEach { item  in
            buttonStack.addArrangedSubview(item)}

        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalSpacing


        [tempInfo, humidityInfo, windInfo].forEach { item in
            weatherInfoStack.addArrangedSubview(item)
        }

        weatherInfoStack.axis = .horizontal
        weatherInfoStack.distribution = .equalSpacing

        view.addSubview(buttonStack)
        view.addSubview(weatherInfoStack)

        view.addSubview(shadowView)
        view.addSubview(greetingLabel)
        view.addSubview(descriptionLabel)

        shadowView.addSubview(iconImageView)

        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonStack.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }


        shadowView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(175)
        }

        iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        weatherInfoStack.snp.makeConstraints { make in
            make.top.equalTo(shadowView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func showImageForCurrentTime(image: UIImage?) {
        self.iconImageView.image = image
    }

    func showGreetingForCurrentTime(text: String) {
        self.greetingLabel.text = text
    }

    func showCurrentWeatherData(with weather: WeatherData) {
        tempInfo.label.text = "\(weather.current.temp)°C"
        humidityInfo.label.text = "\(weather.current.humidity) %"
        windInfo.label.text = "\(weather.current.windSpeed) m/s"
    }
}
