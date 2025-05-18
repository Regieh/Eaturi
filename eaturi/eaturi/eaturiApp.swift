import SwiftUI
import SwiftData
import HealthKit

@main
struct eaturiApp: App {
    let sharedModelContainer: ModelContainer = createContainer()
    let healthManager = HealthManager()
    
    init() {
        healthManager.requestAuthorization()
        
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
        }
        .modelContainer(sharedModelContainer)
    }

    @MainActor
    static func createContainer() -> ModelContainer {
        let schema = Schema([
            HistoryRecord.self,
            FoodModel.self
        ])
        let configuration = ModelConfiguration("eaturiDatabase", schema: schema)

        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            var foodFetchDescriptor = FetchDescriptor<FoodModel>()
            foodFetchDescriptor.fetchLimit = 1

            let existingFoodItems = try container.mainContext.fetch(foodFetchDescriptor)

            if existingFoodItems.isEmpty {
                print("FoodModel database is empty. Seeding sample data from JSON...")
                let itemsToSeed = loadFoodData() // Use the JSON loading function
                if itemsToSeed.isEmpty {
                    print("Warning: No items loaded from JSON. Database will remain empty.")
                } else {
                    for item in itemsToSeed {
                        container.mainContext.insert(item)
                    }
                    try? container.mainContext.save()
                    print("FoodModel sample data seeded successfully. Loaded \(itemsToSeed.count) items.")
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

// Function to load JSON from foodData.json (defined outside the App struct)
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
