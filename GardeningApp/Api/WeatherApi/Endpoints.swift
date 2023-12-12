//
//
// GardeningApp
// Endpoints.swift
// 
// Created by Alexander Kist on 11.12.2023.
//


import Foundation

struct Api {
    static let baseUrl = "https://api.openweathermap.org/data/3.0"
}

protocol Endpoint {
    var path: String { get }
    var url: String { get }
    var parameters: [String: String] { get }
}

extension Endpoint {
    var url: String {
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        var components = URLComponents(string: "\(Api.baseUrl)\(path)")
        components?.queryItems = queryItems
        return components?.url?.absoluteString ?? ""
    }

}

enum Endpoints {
    enum Weather: Endpoint {
        case oneCall(latitude: Double, longitude: Double, apiKey: String, units: String = "metric")

        public var path: String {
            return "/onecall"
        }

        public var parameters: [String: String] {
            switch self {
            case .oneCall(let latitude, let longitude, let apiKey, let units):
                return [
                    "lat": String(latitude),
                    "lon": String(longitude),
                    "appid": apiKey,
                    "units": units
                ]
            }
        }
    }
}
