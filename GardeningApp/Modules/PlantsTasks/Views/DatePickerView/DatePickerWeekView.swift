//
//
// GardeningApp
// GreetingsView.swift
//
// Created by Alexander Kist on 12.12.2023.
//

import SwiftUI

public struct DatePickerWeekView: View {
    @Binding var date: Date
    @Binding var page: Int

    public init(date: Binding<Date>, page: Binding<Int>) {
        self._date = date
        self._page = page
    }

    func calculatePageDate(_ page: Int) -> Date {
        Calendar.current.date(
            byAdding: .day,
            value: page * 7,
            to: Date.now.todayStartPoint
        )!
    }

    public var body: some View {
        GeometryReader { geometry in
            InfiniteTabPageView(
                width: geometry.size.width,
                page: $page
            ) { page in
                VStack {
                    WeekView(
                        date: $date,
                        weekDays: calculatePageDate(page).weekDays(),
                        id: UUID().uuidString
                    )
                }
            }
        }
    }
}
