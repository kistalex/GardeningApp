//
//
// GardeningApp
// HomeModuleEventsDelegate.swift
// 
// Created by Alexander Kist on 12.12.2023.
//


import Foundation

protocol HomeModuleEventsDelegate: AnyObject {
    func didTapButton(sender: GardenHeader)
    func didTapSearchButton(sender: ButtonView)
    func didTapNotificationButton(sender: ButtonView)
}
