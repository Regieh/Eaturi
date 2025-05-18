import SwiftUI
import _SwiftData_SwiftUI

struct HistoryCardView: View {
    let record: HistoryRecord
    let onPickAgain: ([UUID: Int]) -> Void

    @Query private var foodItems: [FoodModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with meal type
            Text("Lunch Logged")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.leading, 20)

            // Show each food item once with its quantity
            ForEach(Array(record.cart.keys), id: \.self) { productID in
                if let food = foodItems.first(where: { $0.id == productID }),
                   let quantity = record.cart[productID] {
                    MealCardView(food: food, quantity: quantity)
                }
            }

            // "Pick Again" Button
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
                
                // Nutrient Info
                HStack(spacing: 6) {
                    nutrientChip(icon: "drop.fill", value: food.fat * quantity, color: .blue)
                    nutrientChip(icon: "fish.fill", value: food.protein * quantity, color: .red)
                    nutrientChip(icon: "laurel.trailing", value: food.carbs * quantity, color: .orange)
                    nutrientChip(icon: "leaf.fill", value: food.fiber * quantity, color: .green)
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
    
    // MARK: - Nutrient Chip View
    @ViewBuilder
    private func nutrientChip(icon: String, value: Int, color: Color) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
            Text("\(value)g")
        }
        .font(.footnote)
        .padding(5)
        .background(color.opacity(0.1))
        .foregroundColor(color)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Preview

#Preview {
    do {
        let previewer = try Previewer()
        return MainTabView(cartItems: [:])
            .modelContainer(previewer.container)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
