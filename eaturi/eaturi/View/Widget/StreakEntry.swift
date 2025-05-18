//
//  StreakEntry.swift
//  eaturi
//
//  Created by Flavia Angelina Witarsah on 18/05/25.
//


import WidgetKit
import SwiftUI

struct StreakEntry: TimelineEntry {
    let date: Date
    let streak: Int
}

struct StreakProvider: TimelineProvider {
    let store = UserDefaults(suiteName: "group.com.core.challenge.eaturi") ?? .standard
    
    func placeholder(in context: Context) -> StreakEntry {
        StreakEntry(date: Date(), streak: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (StreakEntry) -> Void) {
        let streak = store.integer(forKey: "streak_current")
        completion(StreakEntry(date: Date(), streak: streak))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StreakEntry>) -> Void) {
        let streak = store.integer(forKey: "streak_current")
        let entry = StreakEntry(date: Date(), streak: streak)
        // Refresh after 1 hour to keep widget data fresh
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }
}

struct StreakWidgetEntryView: View {
    var entry: StreakProvider.Entry
    
    var body: some View {
        VStack {
            Text("Current Streak")
                .font(.headline)
            Text("\(entry.streak)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.orange)
        }
        .padding()
    }
}

struct StreakWidget: Widget {
    let kind: String = "StreakWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StreakProvider()) { entry in
            StreakWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Meal Logging Streak")
        .description("Shows your current consecutive meal logging streak.")
        .supportedFamilies([.systemSmall])
    }
}
