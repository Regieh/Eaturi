//
//  FoodModel.swift
//  KasturiFoodTracker
//
//  Created by Grachia Uliari on 26/03/25.
//
import SwiftUI

struct FoodModel: Identifiable {
    var id = UUID()
    var name: String
    var image: String
    var price: Int
    var calories: Int
    var protein: Int
    var carbs: Int
    var fat: Int
    var fiber: Int
    var description: String
    
    static func generateFood() -> [FoodModel] {
        return [
            FoodModel(
                name: "Ayam Goreng Asam Manis", image: "ayam_asam_manis", price: 25000, calories: 200, protein: 30, carbs: 10, fat: 10, fiber: 30,  description: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, molestias!"
            ),
            FoodModel(
                name: "Telur Balado", image: "telur_balado", price: 10000, calories: 110, protein: 15, carbs: 5, fat: 8, fiber: 3,  description: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, molestias! blablalal"
            ),
            FoodModel(
                name: "Mie Goreng", image: "mie_goreng", price: 15000, calories: 350, protein: 25, carbs: 60, fat: 12, fiber: 7,  description: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, molestias! blablalal"
            ),
            FoodModel(
                name: "Otak-otak", image: "otak_otak", price: 10000, calories: 270, protein: 20, carbs: 40, fat: 11, fiber: 6,  description: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, molestias! blablalal otak-otkakk"
            ),
            FoodModel(
                name: "Ayam Goreng Asam Manis", image: "ayam_asam_manis", price: 25000, calories: 200, protein: 30, carbs: 10, fat: 10, fiber: 30,  description: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, molestias!"
            ),
            FoodModel(
                name: "Telur Balado", image: "telur_balado", price: 10000, calories: 110, protein: 15, carbs: 5, fat: 8, fiber: 3,  description: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, molestias! blablalal"
            ),
        ]
    }
}

