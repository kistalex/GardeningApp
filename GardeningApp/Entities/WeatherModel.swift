//
//
// GardeningApp
// WeatherModel.swift
//
// Created by Alexander Kist on 11.12.2023.
//


import Foundation

struct WeatherModel: Decodable {
    let lat, lon: Double
    let current: Current
}

struct Current: Decodable {
    let temp: Double
    let humidity: Int
    let windSpeed: Double
}
