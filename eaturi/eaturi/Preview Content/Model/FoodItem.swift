//
//  FoodItem.swift
//  eaturi
//
//  Created by Raphael Gregorius on 21/03/25.
//

import Foundation

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let price: String
    let calories: String
    let protein: String
    let carbs: String
    let fiber: String
    let fat: String
}
