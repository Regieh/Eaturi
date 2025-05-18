import SwiftUI
import _SwiftData_SwiftUI

struct HistoryCardView: View {
    let record: HistoryRecord
    let onPickAgain: ([UUID: Int]) -> Void

    @Query private var foodItems: [FoodModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with date and total items
            Text("Lunch Logged")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.horizontal)

            // Each product in its own card
            ForEach(Array(record.cart.keys), id: \.self) { productID in
                if let food = foodItems.first(where: { $0.id == productID }),
                   let quantity = record.cart[productID] {
                    MealCardView(food: food, quantity: quantity)
                }
            }

            HStack {
                Spacer()
                Button(action: {
                    onPickAgain(record.cart)
                }) {
                    Text("Pick Again")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color("colorPrimary"))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                Spacer()
            }
        }
        .padding()
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

// MARK: - Meal Card View

struct MealCardView: View {
    let food: FoodModel
    let quantity: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Image
            Image(food.image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(food.name)
                    .font(.title3)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: 6) {
                    
                    HStack(spacing: 3) {
                        Image(systemName: "drop.fill")
                        Text("\(food.fat * quantity)g")
                    }
                    .font(.footnote)
                    .padding(5)
                    .background(Color.blue.opacity(0.10))
                    .foregroundColor(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    HStack(spacing: 3) {
                        Image(systemName: "heart.fill")
                        Text("\(food.protein * quantity)g")
                    }
                    .font(.footnote)
                    .padding(5)
                    .background(Color.red.opacity(0.10))
                    .foregroundColor(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    HStack(spacing: 3) {
                        Image(systemName: "fork.knife.circle.fill")
                        Text("\(food.carbs * quantity)g")
                    }
                    .font(.footnote)
                    .padding(5)
                    .background(Color.yellow.opacity(0.10))
                    .foregroundColor(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    HStack(spacing: 3) {
                        Image(systemName: "leaf.fill")
                        Text("\(food.fiber * quantity)g")
                    }
                    .font(.footnote)
                    .padding(5)
                    .background(Color.green.opacity(0.10))
                    .foregroundColor(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Spacer(minLength: 3)
                
                
                HStack {
                    Text("\(food.calories * quantity) kcal")
                        .font(.title3)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text("x\(quantity) serving")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Nutrient View
    
    struct NutrientIconView: View {
        let value: Int
        let symbol: String
        let color: Color
        var unit: String = "g"
        
        var body: some View {
            HStack(spacing: 4) {
                Image(systemName: symbol)
                    .font(.caption)
                    .foregroundColor(color)
                Text("\(value)\(unit)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
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
