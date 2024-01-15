//
//
// GardeningApp
// AddPlantTableViewCellItem.swift
// 
// Created by Alexander Kist on 11.01.2024.
//


import Foundation

protocol TableViewCellItemModel: NSObjectProtocol {
    var identifier: String { get }
}

protocol AddPlantTableViewCellItem: NSObjectProtocol {
    var delegate: AddTaskTableViewItemDelegate? { get set }
    func config(with data: Any)
}
