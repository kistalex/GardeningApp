//
//
// GardeningApp
// TaskTableViewItemDelegate.swift
// 
// Created by Alexander Kist on 11.01.2024.
//


import Foundation


protocol TaskTableViewItemDelegate: AnyObject {
    func didSelectDate(_ cell: DatePickerTableViewCell, with date: Date?)
    func buttonCellDidTap(_ cell: AddTaskButtonTableViewCell)
    func todayButtonDidTap(_ cell: CurrentDateTableViewCell)
    func completeButtonDidTap(_ cell: TaskTableViewCell)
}
