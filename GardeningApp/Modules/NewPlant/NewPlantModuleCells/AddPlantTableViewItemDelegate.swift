//
//
// GardeningApp
// AddPlantTableViewItemDelegate.swift
// 
// Created by Alexander Kist on 21.01.2024.
//


import Foundation


protocol AddPlantTableViewItemDelegate: AnyObject {
    func didTapOpenImagePicker(_ cell: PlantImageTableViewCell)
    func didInputPlantName(_ cell: PlantNameTableCell, with name: String)
    func didChoseStartCaringDate(_ cell: DatePlantCaringTableViewCell, with date: Date)
    func didWriteDescription(_ cell: PlantDescriptionTableViewCell, with text: String)
    func didTapSaveButton(_ cell: SavePlantButtonTableViewCell)
}
