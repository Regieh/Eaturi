import SwiftUI
import SwiftData
import HealthKit

struct CartView: View {
    @Binding var cartItems: [UUID: Int]
    var foodItems: [FoodModel]
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    let healthManager = HealthManager()
    
    @Binding var selectedTab: Int
    
    var totalCalories: Int {
        CartCalculationUtility.calculateTotalCalories(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalProtein: Int {
        CartCalculationUtility.calculateTotalProtein(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalFat: Int {
        CartCalculationUtility.calculateTotalFat(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalFiber: Int {
        CartCalculationUtility.calculateTotalFiber(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalCarbs: Int {
        CartCalculationUtility.calculateTotalCarbs(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalPrice: Int {
        CartCalculationUtility.calculateTotalPrice(cartItems: cartItems, foodItems: foodItems)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                
                VStack {
                    VStack (spacing: 16){
                        HStack{
                            Text("Calories")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                            Spacer()
                            Text("\(totalCalories)")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(15)
                        .frame(width: 350)
                        
                        HStack(spacing: 10) {
                            nutritionItem(icon: "drop.fill", value: "\(totalFat)g", label: "Fat", bgColor: Color.blue.opacity(0.1), textColor: .blue)
                            nutritionItem(icon: "heart.fill", value: "\(totalProtein)g", label: "Protein", bgColor: Color.red.opacity(0.1), textColor: .red)
                            nutritionItem(icon: "fork.knife.circle.fill", value: "\(totalCarbs)g", label: "Carbs", bgColor: Color.yellow.opacity(0.1), textColor: .orange)
                            nutritionItem(icon: "leaf.fill", value: "\(totalFiber)g", label: "Fiber", bgColor: Color.green.opacity(0.1), textColor: .green)
                        }
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical, 16)
                    
                    Spacer()

                    ScrollView {
                        VStack(spacing: UIFontMetrics.default.scaledValue(for: 16)) {
                            if cartItems.isEmpty {
                                Text("Your cart is empty")
                                    .font(.system(.body, design: .default))
                                    .foregroundColor(.gray)
                                    .padding()
                                    .dynamicTypeSize(.xSmall...(.accessibility5))
                            } else {
                                ForEach(cartItems.compactMap { key, value -> (FoodModel, Binding<Int>)? in
                                    if let item = foodItems.first(where: { $0.id == key }) {
                                        return (item, Binding(
                                            get: { cartItems[key] ?? 0 },
                                            set: { newValue in updateQuantity(for: key, quantity: newValue) }
                                        ))
                                    }
                                    return nil
                                }, id: \.0.id) { item, quantity in
                                    CartItemView(item: item, quantity: quantity)
                                }
                            }
                        }
                    }

                    Button(action: {
                        saveToHistory()
                    }) {
                        Text("Log my meal")
                            .font(.system(size: UIFontMetrics.default.scaledValue(for: 20)))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(height: UIFontMetrics.default.scaledValue(for: 40))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(cartItems.isEmpty ? Color.gray : Color.colorPrimary)
                            .cornerRadius(100)
                            .padding()
                    }
                    .disabled(cartItems.isEmpty)
                }
                .padding(.top)
            }
        }
//        .navigationTitle("My Meal")
        .navigationBarTitleDisplayMode(.large)
    }

    
    private var background: some View {
        Color("colorBackground")
            .edgesIgnoringSafeArea(.all)
    }
    
    
    func nutritionItem(icon: String, value: String, label: String, bgColor: Color, textColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                    .foregroundColor(textColor)
                Text(label)
                    .font(.footnote)
                    .foregroundColor(textColor)
            }
            Spacer().frame(height: 10)
            Text(value)
                .font(.headline)
                .foregroundColor(textColor)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(bgColor)
        .cornerRadius(15)
    }

    
    private func separator() -> some View {
        Rectangle()
            .fill(Color("colorPrimary"))
            .frame(width: 1, height: UIFontMetrics.default.scaledValue(for: 40))
            .padding(.horizontal, 4)
    }
    
    private func updateQuantity(for id: UUID, quantity: Int) {
        if quantity > 0 {
            cartItems[id] = quantity
        } else {
            cartItems.removeValue(forKey: id)
        }
    }
    
    private func saveToHistory() {
        print("Saving to history...")
        
        let foodData = foodItems.reduce(into: [UUID: (Int, Int, Int, Int, Int, Int)]()) { result, item in
            result[item.id] = (
                item.price,
                item.calories,
                item.protein,
                item.carbs,
                item.fiber,
                item.fat
            )
        }
        
        HistoryManager.saveOrderHistory(
            cart: cartItems,
            modelContext: modelContext,
            foodData: foodData
        )
        
        healthManager.saveNutrition(value: Double(totalCalories), unit: .kilocalorie(), typeIdentifier: .dietaryEnergyConsumed)
        healthManager.saveNutrition(value: Double(totalFat), unit: .gram(), typeIdentifier: .dietaryFatTotal)
        healthManager.saveNutrition(value: Double(totalCarbs), unit: .gram(), typeIdentifier: .dietaryCarbohydrates)
        healthManager.saveNutrition(value: Double(totalFiber), unit: .gram(), typeIdentifier: .dietaryFiber)
        healthManager.saveNutrition(value: Double(totalProtein), unit: .gram(), typeIdentifier: .dietaryProtein)
        
        cartItems.removeAll()
        
        // Switch to History tab (index 1) before dismissing
        selectedTab = 1
        dismiss()
        
        print("Save completed")
    }
}

struct CartItemView: View {
    var item: FoodModel
    @Binding var quantity: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Image
            Image(item.image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
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
                        Image(systemName: "heart.fill")
                        Text("\(item.protein)g")
                    }
                    .font(.footnote)
                    .padding(5)
                    .background(Color.red.opacity(0.10))
                    .foregroundColor(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    HStack(spacing: 3) {
                        Image(systemName: "fork.knife.circle.fill")
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

                
                HStack {
                    Text("\(item.calories) Kcal")
                        .font(.title3)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    QuantityControl(
                        quantity: $quantity,
                        onIncrement: {
                            quantity += 1
                        },
                        onDecrement: {
                            if quantity > 1 {
                                quantity -= 1
                            }
                        },
                        buttonSize: 24,
                        iconSize: 10,
                        fontSize: 16,
                        textSpacing: 0
                    )
                }
                .padding(.top, 3)
            }
        }
        .frame(width: 340, height: 90)
        //        .padding(.top, 8)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        //        .shadow(radius: 5)
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return CartView(
            cartItems: .constant([:]),
            foodItems: [],
            selectedTab: .constant(0)
        )
        .modelContainer(previewer.container)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}

