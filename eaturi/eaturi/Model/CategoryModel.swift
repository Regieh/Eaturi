//
//  CategoryModel.swift
//  eaturi
//
//  Created by Grachia Uliari on 27/03/25.
//
import SwiftUI

struct CategoryModel: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var localName: String
    
    static func generateCategories() -> [CategoryModel] {
        return [
            CategoryModel(name: "Chicken", localName: "Chicken"),
            CategoryModel(name: "Rice", localName: "Rice"),
            CategoryModel(name: "Fish", localName: "Fish"),
            CategoryModel(name: "Beef",localName: "Beef"),
            CategoryModel(name: "Egg", localName: "Egg"),
            CategoryModel(name: "Fried", localName: "Fried"),
            CategoryModel(name: "Veggies", localName: "Veggies"),
            CategoryModel(name: "Sambal", localName: "Sambal"),
            CategoryModel(name: "Others", localName: "Others")
        ]
    }
}
