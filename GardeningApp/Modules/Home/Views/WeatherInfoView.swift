//
//
// GardeningApp
// WeatherInfoView.swift
// 
// Created by Alexander Kist on 12.12.2023.
//


import UIKit

class WeatherInfoView: UIView {

    private let tempInfo = WeatherInfoSection(imageName: "thermometer.medium")
    private let humidityInfo = WeatherInfoSection(imageName: "humidity.fill")
    private let windInfo = WeatherInfoSection(imageName: "wind")
    private let weatherInfoStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews(){
        [tempInfo, humidityInfo, windInfo].forEach { item in
            weatherInfoStack.addArrangedSubview(item)
        }

        weatherInfoStack.axis = .horizontal
        weatherInfoStack.distribution = .equalSpacing

        addSubview(weatherInfoStack)

        weatherInfoStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public func setInfo(with weather: WeatherData){
        tempInfo.label.text = "\(weather.current.temp)°C"
        humidityInfo.label.text = "\(weather.current.humidity) %"
        windInfo.label.text = "\(weather.current.windSpeed) m/s"
    }
}
