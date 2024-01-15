//
//
// GardeningApp
// PlantTaskTableViewItemDelegate.swift
// 
// Created by Alexander Kist on 11.01.2024.
//


import Foundation


protocol PlantTaskTableViewItemDelegate: AnyObject {
    func didSelectDate(_ cell: DatePickerCollectionTableViewCell, with date: Date?)
    func buttonCellDidTapped(_ cell: AddTaskButtonTableViewCell)

//    func didSelectPlantName(_ cell: PlantsNamesCollectionTableViewCell, withName name: String)
//    func didSelectTaskType(_ cell: TaskTypesCollectionTableViewCell, withType type: String)
//    func didSelectDate(_ cell: DatePickerTableViewCell, withDate date: Date)
//    func didWriteDescription(_ cell: TextViewTableViewCell, withText text: String)
//    func buttonCellDidTapped(_ cell: ButtonTableViewCell)
}
