import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \HistoryRecord.timestamp, order: .reverse)
    private var historyRecords: [HistoryRecord]
    
    @Binding var cartItems: [UUID: Int]
    var onPickAgain: ([UUID: Int]) -> Void
    var foodItems: [FoodModel]

    @State private var selectedDate = Date()
    @State private var showDatePicker = false

    private var currentWeekDates: [Date] {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: selectedDate) else {
            return []
        }
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: weekInterval.start)
        }
    }
    
    // Filter records for the selected date only
    private var filteredHistoryRecords: [HistoryRecord] {
        historyRecords.filter { record in
            Calendar.current.isDate(record.timestamp, inSameDayAs: selectedDate)
        }
    }
    
    var totalCalories: Int {
        CartCalculationUtility.calculateTotalCalories(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalProtein: Int {
        CartCalculationUtility.calculateTotalProtein(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalFat: Int {
        CartCalculationUtility.calculateTotalFat(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalFiber: Int {
        CartCalculationUtility.calculateTotalFiber(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalCarbs: Int {
        CartCalculationUtility.calculateTotalCarbs(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalPrice: Int {
        CartCalculationUtility.calculateTotalPrice(cartItems: cartItems, foodItems: foodItems)
    }

    var body: some View {
        ZStack {
            background

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Daily Nutrition")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.leading, 16)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)

                // Date Button
                HStack {
                    Button(action: {
                        withAnimation {
                            showDatePicker = true
                        }
                    }) {
                        Image(systemName: "calendar")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(dateFormatter.string(from: selectedDate))
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 20)

                // Week Calendar
                HStack(spacing: 12) {
                    ForEach(currentWeekDates, id: \.self) { date in
                        VStack {
                            Text(dayOfWeekFormatter.string(from: date))
                                .font(.caption)
                                .foregroundColor(.gray)

                            Text(dayFormatter.string(from: date))
                                .font(.headline)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(isSameDay(date1: date, date2: selectedDate) ? Color.orange : Color.clear)
                                )
                                .foregroundColor(isSameDay(date1: date, date2: selectedDate) ? .white : .black)
                        }
                        .onTapGesture {
                            selectedDate = date
                        }
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
                .padding(.top, 15)
                
                // Nutrition Summary
                VStack(spacing: 16) {
                    HStack {
                        Text("Calories")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                        Spacer()
                        Text("\(totalCalories)")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(15)
                    
                    HStack(spacing: 10) {
                        nutritionItem(icon: "drop.fill", value: "\(totalFat)g", label: "Fat", bgColor: Color.blue.opacity(0.1), textColor: .blue)
                        nutritionItem(icon: "heart.fill", value: "\(totalProtein)g", label: "Protein", bgColor: Color.red.opacity(0.1), textColor: .red)
                        nutritionItem(icon: "fork.knife.circle.fill", value: "\(totalCarbs)g", label: "Carbs", bgColor: Color.yellow.opacity(0.1), textColor: .orange)
                        nutritionItem(icon: "leaf.fill", value: "\(totalFiber)g", label: "Fiber", bgColor: Color.green.opacity(0.1), textColor: .green)
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 16)

                // History Records
                if filteredHistoryRecords.isEmpty {
                    Spacer()
                    Text("No history records found")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredHistoryRecords) { record in
                                HistoryCardView(record: record, onPickAgain: onPickAgain)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            modelContext.delete(record)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 30)
                    }
                }
            }
            .padding(.horizontal)
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 60)
            }

            // Floating Calendar Overlay
            if showDatePicker {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showDatePicker = false
                        }
                    }

                VStack(spacing: 16) {
                    CalendarGridView(selectedDate: $selectedDate) {
                        withAnimation {
                            showDatePicker = false
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding()
                    .shadow(radius: 10)
                }
                .frame(maxWidth: 350)
                .transition(.scale)
                .zIndex(1)
            }
        }
    }

    // MARK: - Nutrition Item View
    private func nutritionItem(icon: String, value: String, label: String, bgColor: Color, textColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                    .foregroundColor(textColor)
                Text(label)
                    .font(.footnote)
                    .foregroundColor(textColor)
            }
            Spacer().frame(height: 10)
            Text(value)
                .font(.headline)
                .foregroundColor(textColor)
        }
        .padding(.horizontal, 17)
        .padding(.vertical, 10)
        .background(bgColor)
        .cornerRadius(15)
    }

    // MARK: - Formatters & Helpers
    private var background: some View {
        Color("colorBackground")
            .edgesIgnoringSafeArea(.all)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    private var dayOfWeekFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }

    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }

    private func isSameDay(date1: Date, date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return HistoryView(
            cartItems: .constant([:]),
            onPickAgain: { _ in },
            foodItems: []
        )
        .modelContainer(previewer.container)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
