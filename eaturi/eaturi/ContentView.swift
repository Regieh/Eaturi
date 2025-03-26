import SwiftUI

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

struct PopularMenu: Identifiable {
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

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Home")
                }

            HistoryView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("History")
                }
        }
    }
}

struct FilterView: View {
    var onSelectFilter: ([String]) -> Void
    var selectedFilters: [String]

    @State private var activeFilters: [String] = []

    let filters = ["Low Carb", "Low Calorie", "High Protein", "Low Fat", "High Fiber"]

    init(onSelectFilter: @escaping ([String]) -> Void, selectedFilters: [String]) {
        self.onSelectFilter = onSelectFilter
        self.selectedFilters = selectedFilters
        _activeFilters = State(initialValue: selectedFilters)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Filter Food")
                .font(.title)
                .fontWeight(.bold)
                .padding()


            HStack {
                ForEach(["Low Carb", "Low Calorie", "Low Fat"], id: \.self) { filter in
                    Button(action: {
                        toggleFilter(filter)
                    }) {
                        Text(filter)
                            .padding()
                            .frame(height: 50)
                            .background(activeFilters.contains(filter) ? Color.orange : Color.gray.opacity(0.1))
                            .foregroundColor(activeFilters.contains(filter) ? .white : .black)
                            .cornerRadius(30)
                    }
                }
            }

            HStack {
                ForEach(["High Protein", "High Fiber"], id: \.self) { filter in
                    Button(action: {
                        toggleFilter(filter)
                    }) {
                        Text(filter)
                            .padding()
                            .frame(height: 50)
                            .background(activeFilters.contains(filter) ? Color.orange : Color.gray.opacity(0.1))
                            .foregroundColor(activeFilters.contains(filter) ? .white : .black)
                            .cornerRadius(30)
                    }
                }
            }

            Spacer()

            HStack {
                Button(action: {
                    activeFilters.removeAll()
                    onSelectFilter([])
                }) {
                    Text("Clear")
                        .foregroundColor(.gray)
                        .padding()
                        .frame(width: 130, height: 40)
                }

                Button(action: {
                    onSelectFilter(activeFilters)
                }) {
                    Text("Apply Filter")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 130, height: 40)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 400, alignment: .top)
        .background(Color.white)
        .cornerRadius(20)
        .presentationDetents([.height(300)])
    }
    
    private func toggleFilter(_ filter: String) {
        if activeFilters.contains(filter) {
            activeFilters.removeAll { $0 == filter }
        } else {
            activeFilters.append(filter)
        }
    }
}

struct QuantityControl: View {
    @Binding var quantity: Int
    var onZeroQuantity: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                if quantity > 1 {
                    quantity -= 1
                } else{
                    onZeroQuantity()
                }
            }) {
                Image(systemName: "minus")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Text("\(quantity)")
                .font(.headline)
                .frame(width: 30)
            
            Button(action: {
                quantity += 1
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .padding()
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding(5)
    }
}

struct CartPopUp: View {
    var totalCalories: Int
    var totalPrice: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your picked food")
                .font(.headline)
                .foregroundStyle(.white)
            Text("Total Calories: \(totalCalories)")
                .foregroundStyle(.white)
                .font(.caption)
            Text("Total Price: Rp\(totalPrice)")
                .foregroundStyle(.white)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.9))
        .cornerRadius(15)
        .padding(.horizontal)
        Spacer()
    }
}

struct FoodDetailView: View {
    let item: FoodItem
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Image(item.image)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, 10)
            Text(item.name)
                .font(.title2)
                .fontWeight(.bold)
            Text("Harga: \(item.price)")
                .font(.headline)
                .foregroundColor(.orange)
                .padding(.top, 4)
            
            Text("Nutrition")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            HStack{
                VStack{
                    Text("Calories")
                        .font(.caption)
                    Text("\(item.calories)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .frame(width: 70, height: 100)
                VStack{
                    Text("Protein")
                        .font(.caption)
                    Text("\(item.protein)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .frame(width: 70, height: 100)
                VStack{
                    Text("Fiber")
                        .font(.caption)
                    Text("\(item.fiber)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .frame(width: 70, height: 100)
                VStack{
                    Text("Fat")
                        .font(.caption)
                    Text("\(item.fat)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .frame(width: 70, height: 100)
                VStack{
                    Text("Carbs")
                        .font(.caption)
                    Text("\(item.carbs)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .frame(width: 70, height: 100)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

struct QuantityControl: View {
    @Binding var quantity: Int
    var onZeroQuantity: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                if quantity > 1 {
                    quantity -= 1
                } else{
                    onZeroQuantity()
                }
            }) {
                Image(systemName: "minus")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Text("\(quantity)")
                .font(.headline)
                .frame(width: 30)
            
            Button(action: {
                quantity += 1
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .padding()
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding(5)
    }
}



struct CartPopUp: View {
    let totalCalories: Int
    let totalPrice: String  // Change from Int to String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Total Calories: \(totalCalories)")
                Text("Total Price: Rp\(totalPrice)")
            }
            Spacer()
            Button("Checkout") { /* Action */ }
        }
        .padding() // Internal padding
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal) // External spacing from screen edges
        .padding(.bottom,80)
    }
}

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var isFilterModalPresented = false
    @State private var selectedFilters: [String] = []
    @State private var cartItems: [UUID: Int] = [:] // use Dictionary to track total item
    @State private var isCartVisible = false
    
    var totalCalories: Int {
            cartItems.reduce(0) { total, entry in
                let item = foodItems.first { $0.id == entry.key }
                return total + ((Int(item?.calories ?? "0") ?? 0) * entry.value)
            }
        }
        
    var totalPrice: Int {
            cartItems.reduce(0) { total, entry in
                let item = foodItems.first { $0.id == entry.key }
                let price = Int(item?.price.replacingOccurrences(of: "Rp", with: "").replacingOccurrences(of: ".", with: "") ?? "0") ?? 0
                return total + (price * entry.value)
            }
        }

    
    var filteredFoodItems: [FoodItem] {
        if selectedFilters.isEmpty { return foodItems }
        
        return foodItems.filter { item in
            var match = true
            
            if selectedFilters.contains("Low Carb") && !(Int(item.carbs.replacingOccurrences(of: "g", with: "")) ?? 0 < 20) {
                match = false
            }
            if selectedFilters.contains("Low Calorie") && !(Int(item.calories) ?? 0 < 250) {
                match = false
            }
            if selectedFilters.contains("High Protein") && !(Int(item.protein.replacingOccurrences(of: "g", with: "")) ?? 0 > 20) {
                match = false
            }
            if selectedFilters.contains("Low Fat") && !(Int(item.fat.replacingOccurrences(of: "g", with: "")) ?? 0 < 10) {
                match = false
            }
            if selectedFilters.contains("High Fiber") && !(Int(item.fiber.replacingOccurrences(of: "g", with: "")) ?? 0 > 5) {
                match = false
            }

            return match
        }
    }
    
    let categories = ["Ayam", "Telur", "Nasi", "Sayur", "Mie", "Gorengan", "Lainnya"]
    let foodItems = [
        FoodItem(name: "Ayam Goreng Asam Manis", image: "ayam_asam_manis", price: "Rp25.000", calories: "200", protein: "30g", carbs: "10g", fiber: "30g", fat: "10g"),
        FoodItem(name: "Nasi Goreng", image: "ayam_asam_manis", price: "Rp20.000", calories: "300", protein: "20g", carbs: "50g", fiber: "5g", fat: "15g"),
        FoodItem(name: "Mie Goreng", image: "mie_goreng", price: "Rp18.000", calories: "350", protein: "25g", carbs: "60g", fiber: "7g", fat: "12g"),
        FoodItem(name: "Telur Balado", image: "telur_balado", price: "Rp15.000", calories: "250", protein: "15g", carbs: "5g", fiber: "3g", fat: "8g"),
        FoodItem(name: "Mie Goreng", image: "ayam_asam_manis", price: "Rp18.000", calories: "350", protein: "25g", carbs: "60g", fiber: "7g", fat: "12g"),
        FoodItem(name: "Telur Balado", image: "telur_balado", price: "Rp15.000", calories: "250", protein: "15g", carbs: "5g", fiber: "3g", fat: "8g")
    ]
    
    let popularMenus = [
        PopularMenu(name: "Telur Balado", image: "telur_balado", price: "Rp. 15.000", calories: "250", protein: "15g", carbs: "5g", fiber: "3g", fat: "8g"),
        PopularMenu(name: "Mie Goreng", image: "ayam_asam_manis", price: "Rp. 18.000", calories: "350", protein: "25g", carbs: "60g", fiber: "7g", fat: "12g"),
        PopularMenu(name: "Ayam Goreng Asam Manis", image: "ayam_asam_manis", price: "Rp. 25.000", calories: "200", protein: "30g", carbs: "10g", fiber: "30g", fat: "10g"),
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let rows = [
        GridItem(.fixed(200)),
        GridItem(.fixed(200)),
    ]
    
    var body: some View {
        ZStack {
//            Color("Beige")
//                .ignoresSafeArea(edges: .all)
            VStack (alignment: .leading){
                Text("Start a \nHealthy Lifestyle")
                    .font(.largeTitle).foregroundColor(Color.black)
                    .fontWeight(.bold)
                    .padding(.leading, 30)
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
//                            .padding(.trailing, 10)
                            .foregroundStyle(Color.black)
                        TextField("What do you want to eat?", text: $searchText)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    
                    Image(systemName: "slider.horizontal.3")
                        .symbolVariant(.fill)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color.black)
                        .onTapGesture {
                            isFilterModalPresented.toggle()
                        }
                        .sheet(isPresented: $isFilterModalPresented) {
                            FilterView(
                                onSelectFilter: { selectedFilters in
                                    self.selectedFilters = selectedFilters
                                    isFilterModalPresented = false
                                },
                                selectedFilters: selectedFilters
                            )
                        

                            
                    }

                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                Text("Popular")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.leading, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(popularMenus) {item in
                            HStack{
                                Image(item.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                VStack(alignment: .leading, spacing: 5){
                                    Text(item.name)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .lineLimit(1)
                                    Text(item.price)
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                    Text("Calories: \(item.calories)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.gray)

                                }
                                .padding(.leading, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                //button add
                            }
                            
                            .padding()
                            .frame(width: 200, height: 100)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            
                        }
                        
                    }
                    .padding(.leading, 20)
                    .frame(maxHeight: 120)
//                    .border(Color.red)
                }
                
                Text("Category")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.leading, 20)
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHStack(spacing: 15) {
                        ForEach(categories, id: \.self) {
                            category in Text(category)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.gray.opacity(0.1))
                                .foregroundColor(Color.black)
                                .cornerRadius(20)
                                .onTapGesture {
                                    print("\(category) selected")
                            }
                        }
                    }
                    .padding(.horizontal, 30)

                }
//                .padding(.bottom, 0)
//                .border(.red)
                .frame(height: 70)
                
                
                
                ScrollView {
                    LazyVGrid (columns: columns, spacing: 0){
                        ForEach(filteredFoodItems) {item in
                            VStack(alignment: .leading){
                                Image(item.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 170, height: 140)
                                    .clipShape(RoundedRectangle(cornerRadius: 0))
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                        Text(item.price)
                                            .font(.subheadline)
                                            .foregroundColor(.red)
                                        Text("Calories: \(item.calories)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                                    
                                    // Quanittiy Button
                                    if let quantity = cartItems[item.id] {
                                        QuantityControl(
                                            quantity: Binding(
                                                get: { cartItems[item.id] ?? 0 },
                                                set: { newValue in
                                                    if newValue > 0 {
                                                        cartItems[item.id] = newValue
                                                    } else {
                                                        cartItems.removeValue(forKey: item.id)
                                                        if cartItems.isEmpty {
                                                            isCartVisible = false
                                                        }
                                                            
                                                    }
                                                }
                                            ),
                                            onZeroQuantity: {
                                                cartItems.removeValue(forKey: item.id)  // Hapus item jika quantity = 0
                                                if cartItems.isEmpty {
                                                    isCartVisible = false
                                                }
                                            }
                                        )
                                    } else {
                                        Button(action: {
                                            cartItems[item.id] = 1
                                            isCartVisible = true
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }

                                .padding(.horizontal, 10)
                                .padding(.top, 0)
                                .padding(.bottom, 20)
                                
                            }
                            .frame(width: 170, height: 200)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding()
                        }
                
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 80)
                    
                }
//                .ignoresSafeArea(edges: .bottom)
                
//                .border(.green)
//                CustomTabBar(selectedIndex: 0)
                             
                
            }
            if isCartVisible && !cartItems.isEmpty {
                CartPopUp(
                    totalCalories: totalCalories,
                    totalPrice: totalPrice.formattedWithSeparator
                )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 20) // Add bottom padding
                    .ignoresSafeArea(.container, edges: .bottom) // Extend to bottom edge
                    .background(Color.clear) // Clear background for proper ZStack layering
            }
            
            
        }
                
    }
}

// Add this extension outside the ContentView struct
extension Int {
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
          .sheet(isPresented: $isFilterModalPresented) {
                                FilterView(
                                    onSelectFilter: { selectedFilters in
                                        self.selectedFilters = selectedFilters
                                        isFilterModalPresented = false
                                    },
                                    selectedFilters: selectedFilters
                                )
                            }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }

                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack(alignment: .leading) {
                            // Popular section ditampilkan waktu search field kosong
                            if searchText.isEmpty {
                                Text("Popular")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.leading, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(popularMenus) { item in
                                            HStack {
                                                Image(item.image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                                VStack(alignment: .leading, spacing: 5) {
                                                    Text(item.name)
                                                        .font(.headline)
                                                        .fontWeight(.medium)
                                                        .lineLimit(1)
                                                    Text(item.price)
                                                        .font(.subheadline)
                                                        .foregroundColor(.red)
                                                    Text("Calories: \(item.calories)")
                                                        .font(.caption)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.gray)
                                                }
                                                .padding(.leading, 10)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            .padding()
                                            .frame(width: 200, height: 100)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(10)
                                        }
                                    }
                                    .padding(.leading, 20)
                                    .frame(maxHeight: 120)
                                }
                                .padding(.bottom, 12)
                                
                                GeometryReader { geometry in
                                    VStack {
                                        Text("Category")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .padding(.leading, 20)
                                            .onAppear {
                                                if geometry.frame(in: .global).minY <= 200 {
                                                    withAnimation {
                                                        isCategoryReached = true
                                                    }
                                                }
                                            }
                                    }
                                }
                                .frame(height: 30)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(categories, id: \.self) { category in
                                            Text(category)
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 10)
                                                .background(Color.gray.opacity(0.1))
                                                .foregroundColor(Color.black)
                                                .cornerRadius(20)
                                                .onTapGesture {
                                                    print("\(category) selected")
                                                }
                                        }
                                    }
                                    .padding(.horizontal, 30)
                                }
                                .frame(height: 70)
                            } else {
                                // Show search results
                                Text("Search Results")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 10)
                            }
                            
                            // No results text
                            if !searchText.isEmpty && filteredFoodItems.isEmpty {
                                VStack(spacing: 20) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray)
                                    Text("No menu items found for \"\(searchText)\"")
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                    Text("Try a different search term or clear the search field")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 50)
                            } else {
                                // Always show food grid (filtered when searching)
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 17) {
                                        ForEach(filteredFoodItems) { item in
                                            VStack(alignment: .leading, spacing: 3) {
                                                ZStack(alignment: .bottomTrailing) {
                                                    Image(item.image)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 160, height: 160)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                        .onTapGesture {
                                                                                        selectedFoodItem = item
                                                                                        showDetailModal = true
                                                                                    }

                                                    if let quantity = cartItems[item.id] {
                                                        HStack(spacing: 5) {
                                                            Button(action: {
                                                                if quantity > 1 {
                                                                    cartItems[item.id] = quantity - 1
                                                                } else {
                                                                    cartItems.removeValue(forKey: item.id)
                                                                    if cartItems.isEmpty {
                                                                        isCartVisible = false
                                                                    }
                                                                }
                                                            }) {
                                                                Image(systemName: "minus")
                                                                    .padding(6)
                                                                    .background(Color.white)
                                                                    .clipShape(Circle())
                                                                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                                            }

                                                            Text("\(quantity)")
                                                                .font(.headline)

                                                            Button(action: {
                                                                cartItems[item.id] = quantity + 1
                                                            }) {
                                                                Image(systemName: "plus")
                                                                    .padding(6)
                                                                    .background(Color.white)
                                                                    .clipShape(Circle())
                                                                    .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                                                            }
                                                        }
                                                        .padding(4)
                                                        .background(Color.white)
                                                        .cornerRadius(30)
                                                        .padding(4)
                                                    } else {
                                                        Button(action: {
                                                            cartItems[item.id] = 1
                                                            isCartVisible = true
                                                        }) {
                                                            Image(systemName: "plus")
                                                                .padding(10)
                                                                .background(Color.blue)
                                                                .foregroundColor(.white)
                                                                .clipShape(Circle())
                                                                .padding(8)
                                                        }
                                                    }
                                                }

                                                Text(item.name)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                    .lineLimit(1)

                                                Text(item.price)
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                
                                                Text("Calories: \(item.calories)")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.red)
                                            }
                                            .frame(width: 164)
                                            .background(Color.white)
                                            .cornerRadius(12)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .sheet(isPresented: $showDetailModal) {
                                    if let item = selectedFoodItem {
                                        FoodDetailView(item: item, isPresented: $showDetailModal)
                                    }
                                }
                            }
                        }
                    }
                }
            }
                
            if isCartVisible && !cartItems.isEmpty {
                VStack {
                    CartPopUp(totalCalories: totalCalories, totalPrice: totalPrice)
                        .padding(.top, 10)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    MainTabView()
}
