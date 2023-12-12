//
//
// GardeningApp
// Extension+UIFont.swift
// 
// Created by Alexander Kist on 11.12.2023.
//


import UIKit

extension UIFont {
    static func largeTitle() -> UIFont {
        return UIFont.preferredFont(forTextStyle: .largeTitle)
    }

    static func title() -> UIFont {
        return UIFont.preferredFont(forTextStyle: .title1)
    }

    static func title3() -> UIFont {
        return UIFont.preferredFont(forTextStyle: .title3)
    }

    static func body() -> UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }

}
