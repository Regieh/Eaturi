import Foundation
import SwiftUI
import Combine

/// A class to manage and track user's meal logging streaks.
/// This class persists the current streak and last logged date using UserDefaults.
/// It is observable and meant to be used in SwiftUI for reactive UI updates.
@MainActor
final class StreakManager: ObservableObject {
    /// The current streak count of consecutive days with a logged meal.
    @Published private(set) var currentStreak: Int = 0

    /// The last calendar day (in the user’s locale) a meal was logged.
    private var lastLoggedDate: Date? = nil
    
    /// Public read-only accessor for last logged date
    var lastLogDate: Date? {
        lastLoggedDate
    }

    /// Key‑value store for persistence — defaults to a dedicated suite to avoid collisions.
    private let store: UserDefaults

    /// Calendar used for date calculations (usually locale-aware current calendar).
    private let calendar: Calendar

    private enum Keys {
        static let streak = "streak_current"
        static let lastDate = "streak_last_date"
    }

    /// Initializes the streak manager with optional custom UserDefaults and Calendar.
    /// - Parameters:
    ///   - store: The UserDefaults store to use (default is custom suite or standard).
    ///   - calendar: Calendar for date calculations (default is `.current`).
    init(
        store: UserDefaults = UserDefaults(suiteName: "com.eaturi.streak") ?? .standard,
        calendar: Calendar = .current
    ) {
        self.store = store
        self.calendar = calendar
        load()
    }

    // MARK: – Public API

    /// Registers that a meal was logged on a specific date.
    ///
    /// - Parameter date: The date when the meal was logged (default is now).
    /// Updates the streak count accordingly.
    func registerMealLogged(at date: Date = .now) {
        let day = calendar.startOfDay(for: date)

        guard let last = lastLoggedDate else {
            // First ever log
            currentStreak = 1
            lastLoggedDate = day
            persist()
            return
        }

        let lastDay = calendar.startOfDay(for: last)
        let components = calendar.dateComponents([.day], from: lastDay, to: day)
        guard let diff = components.day else { return }

        switch diff {
        case 0:
            // Same day – nothing to change
            break
        case 1:
            // Consecutive day – increment streak
            currentStreak += 1
            lastLoggedDate = day
            persist()
        default:
            // Gap in days – reset streak to 1
            currentStreak = 1
            lastLoggedDate = day
            persist()
        }
    }

    /// Resets the streak count and last logged date.
    /// Useful for testing or manual resets.
    func reset() {
        currentStreak = 0
        lastLoggedDate = nil
        persist()
    }

    // MARK: – Persistence

    /// Loads persisted data from UserDefaults.
    private func load() {
        currentStreak = store.integer(forKey: Keys.streak)
        lastLoggedDate = store.object(forKey: Keys.lastDate) as? Date
    }

    /// Persists current streak and last logged date to UserDefaults.
    private func persist() {
        store.set(currentStreak, forKey: Keys.streak)
        store.set(lastLoggedDate, forKey: Keys.lastDate)
    }
}
