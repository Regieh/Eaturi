//
//  HistoryView.swift
//  eaturi
//
//  Created by Grachia Uliari on 21/03/25.
//
import SwiftUI
struct HistoryView: View {
    @State private var selectedHistory: HistoryItem? = nil

    let historyItems: [HistoryItem] = [
        HistoryItem(title: "11 Maret 2025", description: "🔥 500 Calorie", timestamp: "Rp. 25.000,-"),
        HistoryItem(title: "11 Maret 2025", description: "🔥 500 Calorie", timestamp: "Rp. 25.000,-"),
        HistoryItem(title: "11 Maret 2025", description: "🔥 500 Calorie", timestamp: "Rp. 25.000,-")
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("History")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(historyItems) { item in
                            HistoryCardView(historyItem: item, showModal: $selectedHistory)
                        }
                    }
                    .padding()
                }
            }
            .background(Color.white)
            .sheet(item: $selectedHistory) { history in
                HistoryModalView(historyItem: history)
                    .presentationDetents([.medium])
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
