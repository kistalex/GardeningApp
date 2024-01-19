//
//
// GardeningApp
// AddTaskTableViewItemDelegate.swift
// 
// Created by Alexander Kist on 10.01.2024.
//


import Foundation

protocol AddTaskTableViewItemDelegate: AnyObject {
    func didSelectPlant(_ cell: PlantsNamesCollectionTableViewCell, withId id: String)
    func didSelectTaskType(_ cell: TaskTypesCollectionTableViewCell, withType type: String)
    func didSelectDate(_ cell: DueDatePickerTableViewCell, withDate date: Date)
    func didWriteDescription(_ cell: TextViewTableViewCell, withText text: String)
    func buttonCellDidTapped(_ cell: SaveTaskButtonTableViewCell)
}
