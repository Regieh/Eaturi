//
//  HistoryItem.swift
//  eaturi
//
//  Created by Raphael Gregorius on 21/03/25.
//

import Foundation

struct HistoryItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let timestamp: String
}
