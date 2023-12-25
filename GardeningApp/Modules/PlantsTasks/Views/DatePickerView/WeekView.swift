//
//
// GardeningApp
// GreetingsView.swift
//
// Created by Alexander Kist on 12.12.2023.
//

import SwiftUI

struct WeekView: View {
    @Binding var date: Date
    var weekDays: [Date]
    var id: String = ""

    var body: some View {
        HStack {
            ForEach(weekDays, id: \.self) { weekDay in
                VStack {
                    Text(weekDay.toString(format: "EEE"))
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(weekDay == date ? .primary : Color.gray)
                    Spacer()
                        .frame(height: 10)
                    Text(weekDay.toString(format: "d"))
                        .font(.system(size: 16))
                        .monospaced()
                        .foregroundStyle(weekDay == date ? .primary : Color.gray)
                }
                .padding(.vertical)
                .background(
                    Capsule()
                        .foregroundColor(weekDay == date ? .accentDark : .clear)
                )
                .onTapGesture {
                    date = weekDay
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}


