//
//
// GardeningApp
// HomeTableViewCellItem.swift
// 
// Created by Alexander Kist on 23.01.2024.
//


import Foundation

protocol HomeTableViewCellItem: NSObjectProtocol {
    var delegate: HomeTableViewCellItemDelegate? { get set }
    func config(with data: Any)
}
