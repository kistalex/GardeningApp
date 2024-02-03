//
//
// GardeningApp
// ImageProvider.swift
//
// Created by Alexander Kist on 10.12.2023.
//


import Foundation
import UIKit


final class ImageProvider {
    func imageForCurrentTime() -> UIImage {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12:
            return .morning
        case 12..<18:
            return .afternoon
        case 18..<22:
            return .evening
        default:
            return .night
        }
    }
}

