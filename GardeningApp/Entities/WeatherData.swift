//
//
// GardeningApp
// WeatherData.swift
//
// Created by Alexander Kist on 11.12.2023.
//


import Foundation

struct WeatherData: Decodable {
    let lat, lon: Double
    let current: Current
}

struct Current: Decodable {
    let temp: Double
    let humidity: Int
    let windSpeed: Double
}

