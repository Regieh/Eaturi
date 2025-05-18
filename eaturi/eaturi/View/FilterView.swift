//
//  FilterView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct FilterView: View {
    var onSelectFilter: ([String]) -> Void
    var selectedFilters: [String]

    @State private var activeFilters: [String] = []

    let filters = [
        ("Low Carb", "< 20g carbs"),
        ("Low Calorie", "< 250 kcal"),
        ("Low Fat", "< 10g fat"),
        ("High Protein", "> 20g protein"),
        ("High Fiber", "≥ 4g fiber")
    ]

    init(onSelectFilter: @escaping ([String]) -> Void, selectedFilters: [String]) {
        self.onSelectFilter = onSelectFilter
        self.selectedFilters = selectedFilters
        _activeFilters = State(initialValue: selectedFilters)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Filter by")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            HStack {
                ForEach(filters.prefix(2), id: \.0) { filter in
                    filterButton(title: filter.0, subtitle: filter.1)
                }
            }

            HStack {
                ForEach(filters[2...3], id: \.0) { filter in
                    filterButton(title: filter.0, subtitle: filter.1)
                }
            }

            HStack {
                ForEach(filters.suffix(1), id: \.0) { filter in
                    filterButton(title: filter.0, subtitle: filter.1)
                }
            }

            Spacer()

            HStack(spacing: 16) {
                Button(action: {
                    activeFilters.removeAll()
                    onSelectFilter([])
                }) {
                    Text("Clear")
                        .foregroundColor(Color("colorPrimary"))
                        .padding()
                        .frame(width: 130, height: 40)
                        .cornerRadius(20)
                }

                Button(action: {
                    onSelectFilter(activeFilters)
                }) {
                    Text("Apply Filter")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .frame(height: 50)
                        .background(Color("colorPrimary"))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .top)
        .background(Color(.systemBackground))
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(30)
    }

    private func filterButton(title: String, subtitle: String) -> some View {
        Button(action: {
            toggleFilter(title)
        }) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
            }
            .padding()
            .frame(height: 60)
            .frame(width: 180)
            .background(activeFilters.contains(title) ? Color("colorOren") : Color.gray.opacity(0.1))
            .foregroundColor(activeFilters.contains(title) ? Color.white : .newblek)
            .cornerRadius(50)
        }
    }

    private func toggleFilter(_ filter: String) {
        if activeFilters.contains(filter) {
            activeFilters.removeAll { $0 == filter }
        } else {
            activeFilters.append(filter)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return MainTabView(cartItems: [:])
            .modelContainer(previewer.container)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}

