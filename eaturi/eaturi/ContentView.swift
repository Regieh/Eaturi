//
//  ContentView.swift
//  KasturiFoodTracker
//
//  Created by Grachia Uliari on 17/03/25.
//

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

            ForEach(filters, id: \.self) { filter in
                Button(action: {
                    if activeFilters.contains(filter) {
                        activeFilters.removeAll { $0 == filter }
                    } else {
                        activeFilters.append(filter)
                    }
                }) {
                    Text(filter)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(activeFilters.contains(filter) ? Color.blue : Color.blue.opacity(0.1))
                        .foregroundColor(activeFilters.contains(filter) ? .white : .blue)
                        .cornerRadius(12)
                }
            }

            Button(action: {
                onSelectFilter(activeFilters)
            }) {
                Text("Apply Filter")
                    .foregroundColor(.green)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
            }

            Button(action: {
                activeFilters.removeAll()
                onSelectFilter([])
            }) {
                Text("Clear Filter")
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()
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
                VStack {
                    CartPopUp(totalCalories: totalCalories, totalPrice: totalPrice)
                        .padding(.top, 10)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            
        }
                
    }
}

#Preview {
//    ContentView()
    MainTabView()
}
