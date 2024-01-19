//
//
// GardeningApp
// WeatherInfoTableViewCell.swift
// 
// Created by Alexander Kist on 23.01.2024.
//


import UIKit
import SnapKit

class WeatherInfoTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: WeatherInfoTableViewCellModel.self)

    var weatherData: WeatherViewModel

    init(weatherData: WeatherViewModel) {
        self.weatherData = weatherData
    }
}

class WeatherInfoTableViewCell: UITableViewCell, HomeTableViewCellItem {
    weak var delegate: HomeTableViewCellItemDelegate?

    private let tempInfo = WeatherInfoView(imageName: "thermometer.medium")
    private let humidityInfo = WeatherInfoView(imageName: "humidity.fill")
    private let windInfo = WeatherInfoView(imageName: "wind")
    private let weatherInfoStack = UIStackView()

    func config(with data: Any) {
        guard let data = data as? WeatherInfoTableViewCellModel else { return }
        contentView.backgroundColor = .light
        tempInfo.label.text = data.weatherData.temp
        humidityInfo.label.text = data.weatherData.humidity
        windInfo.label.text = data.weatherData.windSpeed
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

        contentView.addSubview(weatherInfoStack)

        weatherInfoStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

