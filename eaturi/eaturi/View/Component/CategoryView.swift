import SwiftUI

struct CategoryView: View {
    
    @EnvironmentObject private var streakManager: StreakManager
    
    @Binding var searchText: String
    @Binding var isCategoryReached: Bool
    @Binding var categoryModels: [CategoryModel]
    @Binding var foodItems: [FoodModel]
    @Binding var selectedFilters: [String]
    @Binding var selectedFoodItem: FoodModel?
    @Binding var showDetailModal: Bool
    @Binding var cartItems: [UUID: Int]
    @Binding var isCartVisible: Bool
    
    @State private var cachedFilteredItems: [FoodModel] = []
    @State private var cachedGroupedItems: [String: [FoodModel]] = [:]
    @State private var cachedSortedCategories: [String] = []
    
    let columns = [
        GridItem(.flexible())
    ]
    
    private func updateCaches() {
        _ = foodItems.filter { $0.isPopular }
        
        var items = foodItems
        
        if !searchText.isEmpty {
            items = items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        let nutritionalFilters = ["Low Carb", "Low Calorie", "High Protein", "Low Fat", "High Fiber"]
        
        let selectedNutritionalFilters = selectedFilters.filter { nutritionalFilters.contains($0) }
        let availableCategories = Set(foodItems.flatMap { $0.categories })
        let selectedCategoryFilters = selectedFilters.filter { availableCategories.contains($0) }
        
        if !selectedFilters.isEmpty && selectedCategoryFilters.isEmpty && selectedNutritionalFilters.isEmpty {
            cachedFilteredItems = []
            cachedGroupedItems = [:]
            cachedSortedCategories = []
            return
        }
        
        if !selectedNutritionalFilters.isEmpty {
            
            items = items.filter { item in
                var match = true
                if selectedNutritionalFilters.contains("Low Carb") && !(item.carbs < 20) {
                    //                    print(item.name)
                    match = false
                }
                if selectedNutritionalFilters.contains("Low Calorie") && !(item.calories < 250) {
                    match = false
                }
                if selectedNutritionalFilters.contains("High Protein") && !(item.protein > 20) {
                    match = false
                }
                if selectedNutritionalFilters.contains("Low Fat") && !(item.fat < 10) {
                    match = false
                }
                if selectedNutritionalFilters.contains("High Fiber") && !(item.fiber >= 4) {
                    match = false
                }
                return match
            }
        }
        
        if !selectedCategoryFilters.isEmpty {
            items = items.filter { item in
                !Set(item.categories).intersection(selectedCategoryFilters).isEmpty
            }
        }
        
        cachedFilteredItems = items
        
        var grouped = [String: [FoodModel]]()
        for item in cachedFilteredItems {
            if let primaryCategory = item.categories.first {
                if grouped[primaryCategory] == nil {
                    grouped[primaryCategory] = []
                }
                grouped[primaryCategory]?.append(item)
            }
        }
        cachedGroupedItems = grouped
        
        let categories = grouped.keys.sorted { cat1, cat2 in
            let index1 = categoryModels.firstIndex { $0.localName == cat1 } ?? Int.max
            let index2 = categoryModels.firstIndex { $0.localName == cat2 } ?? Int.max
            return index1 < index2
        }
        cachedSortedCategories = categories
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if searchText.isEmpty {
                // Show Result Filter Bar only if any nutritional filter selected
                if !selectedFilters.filter({ ["Low Carb", "Low Calorie", "High Protein", "Low Fat", "High Fiber"].contains($0) }).isEmpty {
                    ResultFilterBar(selectedFilters: $selectedFilters)
                }
                
                Text("Favorites Go-to Lunch")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                
                PopularItemsSection(
                    foodItems: foodItems.filter { $0.isPopular },
                    selectedFoodItem: $selectedFoodItem,
                    showDetailModal: $showDetailModal
                )
                .padding(.bottom, 12)
                .padding(.horizontal, 20)
                
                VStack {
                    Text("Categories")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                }
                .frame(height: 30)
                
                CategorySelectionView(
                    categoryModels: categoryModels,
                    selectedFilters: $selectedFilters
                )
                .padding(.bottom, 10)
            } else {
                Text("Search Results")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                    .padding(.top, 6)
                    .padding(.bottom, 1)
                
                Text("\"\(searchText)\" search showing \(cachedFilteredItems.count) result\(cachedFilteredItems.count == 1 ? "" : "s")")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
            }
            
            if cachedFilteredItems.isEmpty {
                EmptySearchResultsView(searchText: searchText)
            } else {
                FoodItemsGrid(
                    sortedCategories: cachedSortedCategories,
                    groupedItems: cachedGroupedItems,
                    selectedFoodItem: $selectedFoodItem,
                    showDetailModal: $showDetailModal,
                    cartItems: $cartItems,
                    isCartVisible: $isCartVisible
                )
                .sheet(item: $selectedFoodItem) { item in
                    FoodDetailView(
                        item: item,
                        isPresented: $showDetailModal,
                        cartItems: $cartItems,
                        isCartVisible: $isCartVisible,
                        showDetailModal: $showDetailModal,
                        isAvailableToday: item.availableDays.contains(getTodayString())
                    )
                    .presentationDetents([.fraction(0.999)])
                    .presentationCornerRadius(40)
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled(false)
                    .onChange(of: showDetailModal) { _, newValue in
                        if !newValue {
                            selectedFoodItem = nil
                        }
                    }
                }
            }
        }
           .onAppear { updateCaches() }
           .onChange(of: searchText) { _, _ in updateCaches() }
           .onChange(of: selectedFilters) { _, _ in updateCaches() }
           .task { updateCaches() }
       }

}

// MARK: - Component Views
struct PopularItemsSection: View {
    let foodItems: [FoodModel]
    @Binding var selectedFoodItem: FoodModel?
    @Binding var showDetailModal: Bool
    
    // Auto-scrolling properties
    @State private var timerScrollIndex: Int = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    // Layout constants
    private let cardWidth: CGFloat = 360
    private let cardHeight: CGFloat = 150
    private let cardSpacing: CGFloat = 12
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        // This spacer creates the left padding for scrolling
                        LazyHStack(spacing: cardSpacing) {
                            ForEach(Array(foodItems.enumerated()).filter { $0.element.availableDays.contains(getTodayString()) }, id: \.offset) { index, item in
                                PopularCardView(
                                    isAvailable: true,
                                    item: .constant(item)
                                )
                                .frame(width: cardWidth, height: cardHeight)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                                .onTapGesture {
                                    selectedFoodItem = item
                                    showDetailModal = true
                                }
                                .id(index)
                            }

                        }
                    }
                }
                .onReceive(timer) { _ in
                    if foodItems.count > 1 {
                        // Scroll to leftPadding first to ensure consistent left padding
                        scrollProxy.scrollTo("leftPadding", anchor: .leading)
                        
                        // Then scroll to the desired item with a slight delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                timerScrollIndex = (timerScrollIndex + 1) % foodItems.count
                                // Use the horizontalPadding value as the anchor offset
                                scrollProxy.scrollTo(timerScrollIndex, anchor: .leading)
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 5)
    }
}

struct CategorySelectionView: View {
    let categoryModels: [CategoryModel]
    @Binding var selectedFilters: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(categoryModels) { category in
                    VStack(spacing: 0) {
                        Text(category.localName)
                            .font(.subheadline)
                            .foregroundColor(selectedFilters.contains(category.localName) ? .white : .black)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(selectedFilters.contains(category.localName) ? Color("colorOren") : Color.white)
                    .cornerRadius(20)
                    .onTapGesture {
                        withAnimation {
                            if selectedFilters == [category.localName] {
                                // Deselect if it's already selected
                                selectedFilters = []
                            } else {
                                // Select only this category
                                selectedFilters = [category.localName]
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct EmptySearchResultsView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text(searchText.isEmpty ? "No menu items found" : "No menu items found for \"\(searchText)\"")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text("Try a different search term or clear the search field")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 50)
    }
}


struct FoodItemsGrid: View {
    let sortedCategories: [String]
    let groupedItems: [String: [FoodModel]]
    @Binding var selectedFoodItem: FoodModel?
    @Binding var showDetailModal: Bool
    @Binding var cartItems: [UUID: Int]
    @Binding var isCartVisible: Bool
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(sortedCategories, id: \.self) { category in
                    if let items = groupedItems[category], !items.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(category)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.top, 5)
                            
                            LazyVGrid(columns: columns, spacing: 17) {
                                ForEach(items) { item in
                                    FoodItemCell(
                                        item: item,
                                        selectedFoodItem: $selectedFoodItem,
                                        showDetailModal: $showDetailModal,
                                        cartItems: $cartItems,
                                        isCartVisible: $isCartVisible
                                    )
                                    .onTapGesture {
                                        selectedFoodItem = item
                                        showDetailModal = true
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

func getTodayString() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "id_ID") // Indonesia
    formatter.dateFormat = "EEEE"
    return formatter.string(from: Date()).capitalized // Capitalize biar jadi 'Senin', 'Selasa', dll
}


struct FoodItemCell: View {
    let item: FoodModel
    var isAvailableToday: Bool {
        let today = getTodayString()
        return item.availableDays.contains(today)
    }
    
    @State private var isShowingDetail = false
    @Binding var selectedFoodItem: FoodModel?
    @Binding var showDetailModal: Bool
    @Binding var cartItems: [UUID: Int]
    @Binding var isCartVisible: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Image
            Image(item.image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .saturation(isAvailableToday ? 1 : 0)
                .opacity(isAvailableToday ? 1 : 0.6)
            
            // Food info + nutrients + calories
            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(.title3)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: 6) {
                    HStack(spacing: 3) {
                        Image(systemName: "drop.fill")
                        Text("\(item.fat)g")
                    }
                    .font(.footnote)
                    .padding(5)
                    .background(Color.blue.opacity(0.10))
                    .foregroundColor(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    HStack(spacing: 3) {
                        Image(systemName: "fish.fill")
                            .font(.caption)
                        Text("\(item.protein)g")
                            .font(.footnote)
                    }
                    .padding(5)
                    .background(Color.red.opacity(0.10))
                    .foregroundColor(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    HStack(spacing: 3) {
                        Image(systemName: "laurel.trailing")
                        Text("\(item.carbs)g")
                    }
                    .font(.footnote)
                    .padding(5)
                    .background(Color.yellow.opacity(0.10))
                    .foregroundColor(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    HStack(spacing: 3) {
                        Image(systemName: "leaf.fill")
                        Text("\(item.fiber)g")
                    }
                    .font(.footnote)
                    .padding(5)
                    .background(Color.green.opacity(0.10))
                    .foregroundColor(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                }
                
                Spacer(minLength: 3)
                
                
                HStack {
                    Text("\(item.calories) Kcal")
                        .font(.title3)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        .grayscale(isAvailableToday ? 0 : 1)
        .opacity(isAvailableToday ? 1 : 0.6)
    }
}


#Preview {
    do {
        let previewer = try Previewer()
        return MainTabView(cartItems: [:])
            .modelContainer(previewer.container)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
