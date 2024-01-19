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

    enum TimeOfDay: String {
        case morning = "morning"
        case afternoon = "afternoon"
        case evening = "evening"
        case night = "night"

        var image: UIImage? {
            return UIImage(named: self.rawValue)
        }
    }

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

