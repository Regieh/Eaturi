//
//  AppIntent.swift
//  eaturi
//
//  Created by Flavia Angelina Witarsah on 18/05/25.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Recipe" }
    static var description: IntentDescription { "This is an example recipe widget." }

    // An example configurable parameter.
    @Parameter(title: "Recipe Name", default: "Fried Rice")
    var favoriteRecipe: String
    
}
