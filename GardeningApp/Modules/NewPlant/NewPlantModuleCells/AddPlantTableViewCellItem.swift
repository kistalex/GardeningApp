//
//
// GardeningApp
// AddPlantTableViewCellItem.swift
// 
// Created by Alexander Kist on 21.01.2024.
//


import Foundation

protocol AddPlantTableViewCellItem: NSObjectProtocol {
    var delegate: AddPlantTableViewItemDelegate? { get set }
    func config(with data: Any)
}
