//
//
// GardeningApp
// GreetingProvider.swift
// 
// Created by Alexander Kist on 11.12.2023.
//


import Foundation

class GreetingProvider {
    
    func greetingForCurrentTime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12:
            return "Good morning!"
        case 12..<17:
            return "Good afternoon!"
        case 17..<22:
            return "Good evening!"
        default:
            return "Good night!"
        }
    }
}
