//
//
// GardeningApp
// WeatherApiManager.swift
// 
// Created by Alexander Kist on 11.12.2023.
//


import Foundation
import Alamofire

protocol WeatherApiManagerProtocol: AnyObject {
    func fetchCurrentWeather(latitude lat: Double, longitude long: Double, completion: @escaping (Result<WeatherData, Error>) -> Void)
}

final class WeatherApiManager: WeatherApiManagerProtocol {
    func fetchCurrentWeather(latitude lat: Double, longitude long: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let endpoint = Endpoints.Weather.oneCall(latitude: lat, longitude: long, apiKey: "")
        AF.request(endpoint.url, method: .get)
            .validate()
            .responseDecodable(of: WeatherData.self, decoder: decoder) { response in
                switch response.result{
                case .success(let weatherData):
                    completion(.success(weatherData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

