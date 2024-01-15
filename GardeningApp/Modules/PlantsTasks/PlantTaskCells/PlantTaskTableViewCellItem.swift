//
//
// GardeningApp
// PlantTaskTableViewCellItem.swift
// 
// Created by Alexander Kist on 11.01.2024.
//


import Foundation

protocol PlantTaskTableViewCellItem: NSObjectProtocol {
    var delegate: PlantTaskTableViewItemDelegate? { get set }
    func config(with data: Any)
}
