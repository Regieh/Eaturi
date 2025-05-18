//
//  CalendarGridView.swift
//  eaturi
//
//  Created by Flavia Angelina Witarsah on 16/05/25.
//

import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    var onSelect: () -> Void

    private let calendar = Calendar.current
    private let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    private var currentMonthDates: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else { return [] }

        var dates: [Date] = []
        var current = monthInterval.start

        // Pad the start of the month with empty days to align with weekday
        let weekday = calendar.component(.weekday, from: current)
        if weekday > 1 {
            dates += Array(repeating: Date.distantPast, count: weekday - 1)
        }

        while current < monthInterval.end {
            dates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        return dates
    }

    var body: some View {
        VStack {
            // Month Title
            Text(monthYearFormatter.string(from: selectedDate))
                .font(.headline)

            // Weekday headers
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }

            // Date grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(currentMonthDates, id: \.self) { date in
                    if date == Date.distantPast {
                        Color.clear.frame(height: 36)
                    } else {
                        Text("\(calendar.component(.day, from: date))")
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(isSameDay(date1: date, date2: selectedDate) ? Color.orange : Color.clear)
                            )
                            .foregroundColor(isSameDay(date1: date, date2: selectedDate) ? .white : .primary)
                            .onTapGesture {
                                selectedDate = date
                                onSelect()
                            }
                    }
                }
            }
        }
        .padding()
    }

    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }

    private func isSameDay(date1: Date, date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
