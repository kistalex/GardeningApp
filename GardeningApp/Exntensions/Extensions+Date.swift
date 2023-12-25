//
//
// GardeningApp
// Extensions+Date.swift
// 
// Created by Alexander Kist on 25.12.2023.
//


import Foundation

extension Date {
    func weekDays() -> [Date] {
        var result: [Date] = .init()

        guard let startOfWeek = Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: self
            )
        ) else {
            return result
        }

        (0...6).forEach { day in
            if let weekday = Calendar.current.date(
                byAdding: .day,
                value: day,
                to: startOfWeek
            ) {
                result.append(weekday)
            }
        }

        return result
    }

    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = format

        return formatter.string(from: self)
    }

    var todayStartPoint: Date {
        Calendar.current.startOfDay(for: self)
    }
}
