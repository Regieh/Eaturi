import SwiftUI
import SwiftData

struct HistoryView: View {
    // MARK: – Data
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \HistoryRecord.timestamp, order: .reverse)
    private var historyRecords: [HistoryRecord]
    
    // ✅  No live-cart binding anymore
    var onPickAgain: ([UUID: Int]) -> Void

    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    
    // MARK: – Date helpers
    private var currentWeekDates: [Date] {
        let cal = Calendar.current
        guard let week = cal.dateInterval(of: .weekOfMonth, for: selectedDate) else { return [] }
        return (0..<7).compactMap { cal.date(byAdding: .day, value: $0, to: week.start) }
    }
    
    private var filteredHistoryRecords: [HistoryRecord] {
        historyRecords.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: selectedDate) }
    }
    
    // MARK: – Nutrition totals (sum over today’s records)
    private var totalCalories: Int { filteredHistoryRecords.reduce(0) { $0 + $1.totalCalories } }
    private var totalProtein : Int { filteredHistoryRecords.reduce(0) { $0 + $1.totalProtein  } }
    private var totalFat     : Int { filteredHistoryRecords.reduce(0) { $0 + $1.totalFat      } }
    private var totalFiber   : Int { filteredHistoryRecords.reduce(0) { $0 + $1.totalFiber    } }
    private var totalCarbs   : Int { filteredHistoryRecords.reduce(0) { $0 + $1.totalCarbs    } }
    private var totalPrice   : Int { filteredHistoryRecords.reduce(0) { $0 + $1.totalPrice    } }
    
    // MARK: – Body
    var body: some View {
        ZStack {
            Color("colorBackground").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Daily Nutrition")
                        .font(.title).bold()
                        .foregroundColor(.black)
                        .padding(.leading, 16)
                    Spacer()
                }
                .padding(.top, 20)
                
                // Date selector
                HStack {
                    Button {
                        withAnimation { showDatePicker = true }
                    } label: {
                        Image(systemName: "calendar")
                            .font(.subheadline).foregroundColor(.gray)
                        Text(dateFormatter.string(from: selectedDate))
                            .font(.body).foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 20)
                
                // Week strip
                HStack(spacing: 12) {
                    ForEach(currentWeekDates, id: \.self) { date in
                        VStack {
                            Text(dayOfWeekFormatter.string(from: date))
                                .font(.caption).foregroundColor(.gray)
                            
                            Text(dayFormatter.string(from: date))
                                .font(.headline)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(isSameDay(date, selectedDate) ? Color.orange : .clear)
                                )
                                .foregroundColor(isSameDay(date, selectedDate) ? .white : .black)
                        }
                        .onTapGesture { selectedDate = date }
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                .padding(.top, 15)
                
                // Nutrition summary
                VStack(spacing: 16) {
                    HStack {
                        Text("Calories")
                            .font(.subheadline).foregroundColor(.orange)
                        Spacer()
                        Text("\(totalCalories)")
                            .font(.title).fontWeight(.semibold).foregroundColor(.orange)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(15)
                    
                    HStack(spacing: 10) {
                        nutritionItem(icon: "drop.fill",
                                      value: "\(totalFat)g", label: "Fat",
                                      bg: Color.blue.opacity(0.1), fg: .blue)
                        nutritionItem(icon: "fish.fill",
                                      value: "\(totalProtein)g", label: "Protein",
                                      bg: Color.red.opacity(0.1), fg: .red)
                        nutritionItem(icon: "laurel.trailing",
                                      value: "\(totalCarbs)g", label: "Carbs",
                                      bg: Color.yellow.opacity(0.1), fg: .orange)
                        nutritionItem(icon: "leaf.fill",
                                      value: "\(totalFiber)g", label: "Fiber",
                                      bg: Color.green.opacity(0.1), fg: .green)
                    }
                }
                .padding(.vertical, 16)
                
                // History list
                if filteredHistoryRecords.isEmpty {
                    Spacer()
                    Text("No history records found")
                        .foregroundColor(.gray).padding()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredHistoryRecords) { record in
                                HistoryCardView(record: record, onPickAgain: onPickAgain)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            modelContext.delete(record)
                                        } label: { Label("Delete", systemImage: "trash") }
                                    }
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 30)
                    }
                }
            }
            .padding(.horizontal)
            .safeAreaInset(edge: .top) { Color.clear.frame(height: 60) }
            
            // Calendar overlay
            if showDatePicker {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showDatePicker = false } }
                
                VStack {
                    CalendarGridView(selectedDate: $selectedDate) {
                        withAnimation { showDatePicker = false }
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
    
    // MARK: – One nutrition box
    private func nutritionItem(icon: String,
                               value: String,
                               label: String,
                               bg: Color,
                               fg: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 10)).foregroundColor(fg)
                Text(label).font(.footnote).foregroundColor(fg)
            }
            Spacer().frame(height: 10)
            Text(value).font(.headline).foregroundColor(fg)
        }
        .padding(.horizontal, 17)
        .padding(.vertical, 10)
        .background(bg)
        .cornerRadius(15)
    }
    
    // MARK: – Formatters & helpers
    private var dateFormatter: DateFormatter {
        let f = DateFormatter(); f.dateStyle = .long; return f
    }
    private var dayOfWeekFormatter: DateFormatter {
        let f = DateFormatter(); f.dateFormat = "E";  return f
    }
    private var dayFormatter: DateFormatter {
        let f = DateFormatter(); f.dateFormat = "d";  return f
    }
    private func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        Calendar.current.isDate(d1, inSameDayAs: d2)
    }
}

//// MARK: – Preview
//#Preview {
//    do {
//        let previewer = try Previewer()
//        return HistoryView(
//            onPickAgain: { _ in }
//        )
//        .modelContainer(previewer.container)
//    } catch {
//        return Text("Preview error: \(error.localizedDescription)")
//    }
//}

#Preview {
    do {
        let previewer = try Previewer()
        return MainTabView(cartItems: [:])
            .modelContainer(previewer.container)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
