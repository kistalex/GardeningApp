//
//
// GardeningApp
// HomeTableViewCellItemDelegate.swift
// 
// Created by Alexander Kist on 12.12.2023.
//


import Foundation

protocol HomeTableViewCellItemDelegate: AnyObject {
    func didTapAddNewPlantButton(_ cell: GardenHeaderTableViewCell)
    func didTapSearchButton(_ cell: ButtonsTableViewCell)
    func didTapNotificationButton(_ cell: ButtonsTableViewCell)
    func didTapOpenGardenInfo(_ cell: UserPlantCollectionTableViewCell, plant: PlantViewModel)
    func didTapOpenTaskList(_ cell: ImageTableViewCell)
}
