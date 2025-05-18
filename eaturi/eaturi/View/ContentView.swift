import SwiftUI

struct ContentView: View {
    // MARK: - Environment
    @EnvironmentObject var streakManager: StreakManager
    
    // MARK: - Properties
    @State private var searchText = ""
    @State private var isFilterModalPresented = false
    @State private var selectedFilters: [String] = []
    @Binding var cartItems: [UUID: Int]
    @Binding var isCartVisible: Bool
    @State private var isCategoryReached = false
    @State var categoryModels = CategoryModel.generateCategories()
    @State private var selectedFoodItem: FoodModel?
    @State private var showDetailModal = false
    @State private var navigationPath = NavigationPath()
    @State private var showStreakModal = false
    
    @Binding var foodItems: [FoodModel]
    @Binding var selectedTab: Int
    @Binding var shouldNavigateToCart: Bool
    
    // MARK: - Computed Properties
    
    private var nutritionTotals: (calories: Int, protein: Int, fat: Int, carbs: Int, fiber: Int, price: Int) {
        cartItems.reduce((0, 0, 0, 0, 0, 0)) { totals, entry in
            guard let item = foodItems.first(where: { $0.id == entry.key }) else {
                return totals
            }
            
            let quantity = entry.value
            return (
                totals.0 + (item.calories * quantity),
                totals.1 + (item.protein * quantity),
                totals.2 + (item.fat * quantity),
                totals.3 + (item.carbs * quantity),
                totals.4 + (item.fiber * quantity),
                totals.5 + (item.price * quantity)
            )
        }
    }
    
    var totalCalories: Int { nutritionTotals.calories }
    var totalProtein: Int { nutritionTotals.protein }
    var totalFat: Int { nutritionTotals.fat }
    var totalCarbs: Int { nutritionTotals.carbs }
    var totalFiber: Int { nutritionTotals.fiber }
    var totalPrice: Int { nutritionTotals.price }
    
    var popularMenus: [FoodModel] {
        foodItems.filter { $0.isPopular }
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                background
                
                VStack {
                    headerSection
                    
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            CategoryView(
                                searchText: $searchText,
                                isCategoryReached: $isCategoryReached,
                                categoryModels: $categoryModels,
                                foodItems: .constant(sortedFoodItems),
                                selectedFilters: $selectedFilters,
                                selectedFoodItem: $selectedFoodItem,
                                showDetailModal: $showDetailModal,
                                cartItems: $cartItems,
                                isCartVisible: $isCartVisible
                            )
                        }
                    }
                }
                
                // Cart popup
                if isCartVisible && !cartItems.isEmpty {
                    CartPopUp(cartItems: $cartItems, foodItems: $foodItems, isCartVisible: $isCartVisible) {
                        shouldNavigateToCart = true
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 15)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .onChange(of: cartItems) { newCart in
                if !newCart.isEmpty {
                    streakManager.registerMealLogged()
                }
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "cart" {
                    CartView(
                        cartItems: $cartItems,
                        foodItems: foodItems,
                        selectedTab: $selectedTab
                    )
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var background: some View {
        Color("colorBackground")
            .edgesIgnoringSafeArea(.all)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Let Eaturi do Your")
                        .font(.system(.title, design: .default))
                        .dynamicTypeSize(.xSmall...(.accessibility5))
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Text("Calcu-lunching.")
                        .font(.system(.title, design: .default))
                        .dynamicTypeSize(.xSmall...(.accessibility5))
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                }
                .padding(.leading, 30)
                
                Spacer()
                
                Button {
                    showStreakModal = true
                } label: {
                    StreakBadge(count: streakManager.currentStreak)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 24)
            }
            .sheet(isPresented: $showStreakModal) {
                StreakDetailView()
                    .environmentObject(streakManager)
                    .presentationDetents([.fraction(0.999)])
                    .presentationCornerRadius(40)
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled(false)
            }
            
            SearchBar(
                searchText: $searchText,
                isFilterModalPresented: $isFilterModalPresented,
                selectedFilters: $selectedFilters
            )
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 60)
        }
    }
    
    private var sortedFoodItems: [FoodModel] {
        let today = getTodayString()
        return foodItems.sorted { first, second in
            let firstAvailable = first.availableDays.contains(today)
            let secondAvailable = second.availableDays.contains(today)
            
            if firstAvailable && !secondAvailable {
                return true
            } else if !firstAvailable && secondAvailable {
                return false
            } else {
                return first.name < second.name
            }
        }
    }
}

// MARK: - Preference Key

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Preview

#Preview {
    do {
        let previewer = try Previewer()
        return MainTabView(cartItems: [:])
            .modelContainer(previewer.container)
            .environmentObject(StreakManager()) // Add environmentObject for preview
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
