//
//
// GardeningApp
// TaskTableViewCellItem.swift
// 
// Created by Alexander Kist on 11.01.2024.
//


import Foundation

protocol TaskTableViewCellItem: NSObjectProtocol {
    var delegate: TaskTableViewItemDelegate? { get set }
    func config(with data: Any)
}


