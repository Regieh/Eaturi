import SwiftUI
import SwiftData
import HealthKit

@main
struct eaturiApp: App {
    // Shared SwiftData model container
    let sharedModelContainer: ModelContainer = Self.createContainer()
    // HealthKit manager instance
    let healthManager = HealthManager()
    
    // Shared StreakManager observable object
    @StateObject private var streakManager = StreakManager()
    
    init() {
        // Request HealthKit authorization on app launch
        healthManager.requestAuthorization()
        
        // Customize UINavigationBar appearance globally
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = .black
    }

    var body: some Scene {
        WindowGroup {
            MainTabView(cartItems: [:])
                .environmentObject(streakManager)  // Inject StreakManager environment object
        }
        .modelContainer(sharedModelContainer)  // Inject SwiftData container
    }

    @MainActor
    static func createContainer() -> ModelContainer {
        // Define your data model schema here
        let schema = Schema([
            HistoryRecord.self,
            FoodModel.self
        ])
        let configuration = ModelConfiguration("eaturiDatabase", schema: schema)

        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])

            // Check if FoodModel data exists; if not, seed from JSON
            let foodFetchDescriptor = FetchDescriptor<FoodModel>()
            let existingFoodItems = try container.mainContext.fetch(foodFetchDescriptor)

            if existingFoodItems.isEmpty {
                print("FoodModel database is empty. Seeding sample data from JSON...")
                let itemsToSeed = loadFoodData()
                if itemsToSeed.isEmpty {
                    print("Warning: No items loaded from JSON. Database will remain empty.")
                } else {
                    for item in itemsToSeed {
                        container.mainContext.insert(item)
                    }
                    try container.mainContext.save()
                    print("FoodModel sample data seeded successfully with \(itemsToSeed.count) items.")
                }
            } else {
                print("FoodModel database already contains data.")
            }

            return container
        } catch {
            fatalError("Failed to create or seed ModelContainer: \(error)")
        }
    }
}

/// Loads FoodModel data from foodData.json bundled with the app.
/// - Returns: Array of FoodModel objects or empty array on failure.
func loadFoodData() -> [FoodModel] {
    guard let url = Bundle.main.url(forResource: "foodData", withExtension: "json") else {
        print("Error: Could not find foodData.json in bundle")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let foodItems = try decoder.decode([FoodModel].self, from: data)
        return foodItems
    } catch {
        print("Error decoding foodData.json: \(error)")
        return []
    }
}
