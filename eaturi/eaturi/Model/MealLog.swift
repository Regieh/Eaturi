//
//  MealLog.swift
//  eaturi
//
//  Created by Flavia Angelina Witarsah on 18/05/25.
//


import SwiftData
import Foundation
import SwiftUI

@Model
class MealLog {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var cartData: Data
    var totalPrice: Int
    var totalCalories: Int
    var totalProtein: Int
    var totalCarbs: Int
    var totalFiber: Int
    var totalFat: Int
    var totalQuantity: Int
    
    var cart: [UUID: Int] {
        get {
            do {
                return try JSONDecoder().decode([UUID: Int].self, from: cartData)
            } catch {
                print("Error decoding cart: \(error)")
                return [:]
            }
        }
        set {
            do {
                cartData = try JSONEncoder().encode(newValue)
            } catch {
                print("Error encoding cart: \(error)")
                cartData = Data()
            }
        }
    }
    
    init(
        cart: [UUID: Int],
        totalPrice: Int,
        totalCalories: Int,
        totalProtein: Int,
        totalCarbs: Int,
        totalFiber: Int,
        totalFat: Int,
        totalQuantity: Int
    ) {
        self.id = UUID()
        self.timestamp = Date()
        self.cartData = try! JSONEncoder().encode(cart)
        self.totalPrice = totalPrice
        self.totalCalories = totalCalories
        self.totalProtein = totalProtein
        self.totalCarbs = totalCarbs
        self.totalFiber = totalFiber
        self.totalFat = totalFat
        self.totalQuantity = totalQuantity
    }
}

/// Manages saving MealLogs and updating streak
@MainActor
final class MealLogManager: ObservableObject {
    private let modelContext: ModelContext
    private let streakManager: StreakManager
    
    init(modelContext: ModelContext, streakManager: StreakManager) {
        self.modelContext = modelContext
        self.streakManager = streakManager
    }
    
    /// Saves a new meal log and updates streak
    func saveMealLog(
        cart: [UUID: Int],
        totalPrice: Int,
        totalCalories: Int,
        totalProtein: Int,
        totalCarbs: Int,
        totalFiber: Int,
        totalFat: Int,
        totalQuantity: Int
    ) async throws {
        let newMeal = MealLog(
            cart: cart,
            totalPrice: totalPrice,
            totalCalories: totalCalories,
            totalProtein: totalProtein,
            totalCarbs: totalCarbs,
            totalFiber: totalFiber,
            totalFat: totalFat,
            totalQuantity: totalQuantity
        )
        
        modelContext.insert(newMeal)
        try modelContext.save()
        
        // Update streak after successful save
        streakManager.registerMealLogged(at: newMeal.timestamp)
    }
}
