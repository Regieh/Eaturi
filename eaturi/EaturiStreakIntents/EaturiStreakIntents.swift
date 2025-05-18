//
//  EaturiStreakIntents.swift
//  EaturiStreakIntents
//
//  Created by Flavia Angelina Witarsah on 18/05/25.
//

import AppIntents

struct EaturiStreakIntents: AppIntent {
    static var title: LocalizedStringResource { "EaturiStreakIntents" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
