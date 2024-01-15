//
//
// GardeningApp
// AddTaskTableViewItemDelegate.swift
// 
// Created by Alexander Kist on 10.01.2024.
//


import Foundation

protocol AddTaskTableViewItemDelegate: AnyObject {
    func didSelectPlantName(_ cell: PlantsNamesCollectionTableViewCell, withName name: String)
    func didSelectTaskType(_ cell: TaskTypesCollectionTableViewCell, withType type: String)
    func didSelectDate(_ cell: DatePickerTableViewCell, withDate date: Date)
    func didWriteDescription(_ cell: TextViewTableViewCell, withText text: String)
    func buttonCellDidTapped(_ cell: SaveTaskButtonTableViewCell)
}
