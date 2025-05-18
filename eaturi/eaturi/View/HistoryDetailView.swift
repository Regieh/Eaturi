import SwiftUI
import SwiftData

struct HistoryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss // Add this to support dismissal
    @Query private var foodItems: [FoodModel]
    
    var record: HistoryRecord
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color("colorSecondary"), location: 0.0),
                    .init(color: Color("colorSecondary").opacity(0.3), location: 0.3),
                    .init(color: Color("abubg"), location: 0.6)
                ]),
                startPoint: .topTrailing,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
            
            VStack {
                // Custom header with back button
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.backward.circle.fill")
                            .resizable()
                            .foregroundColor(Color.colorPrimary)
                            .frame(width: 33, height: 33)
                    }
                    
                    HStack(spacing: 8) {
                        Text("History")
                            .font(.title)
                            .bold()
                            .foregroundColor(.blackGray)
                        
                        Text("Detail")
                            .font(.title)
                            .bold()
                            .foregroundColor(.colorPrimary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header section
                        VStack(alignment: .leading, spacing: 8) {
                            Text(dateFormatter.string(from: record.timestamp))
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("\(record.totalQuantity) items · Rp \(record.totalPrice)")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, 10)
                        
                        // Nutrition summary
                        NutritionSummaryView(record: record)
                        
                        // Food items list
                        Text("Items")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        
                        ForEach(Array(record.cart.keys), id: \.self) { foodId in
                            if let quantity = record.cart[foodId],
                               let food = findFood(byId: foodId) {
                                FoodItemView(food: food, quantity: quantity)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
    
    private func findFood(byId id: UUID) -> FoodModel? {
        return foodItems.first { $0.id == id }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

// Nutrition summary component
struct NutritionSummaryView: View {
    let record: HistoryRecord
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Nutrition Summary")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                NutritionCard(
                    icon: "flame.fill",
                    color: .orange,
                    title: "Calories",
                    value: "\(record.totalCalories) kcal"
                )
                
                NutritionCard(
                    icon: "bolt.fill",
                    color: .red,
                    title: "Protein",
                    value: "\(record.totalProtein) g"
                )
            }
            
            HStack(spacing: 12) {
                NutritionCard(
                    icon: "chart.pie.fill",
                    color: .blue,
                    title: "Carbs",
                    value: "\(record.totalCarbs) g"
                )
                
                NutritionCard(
                    icon: "drop.fill",
                    color: .green,
                    title: "Fiber",
                    value: "\(record.totalFiber) g"
                )
            }
            
            NutritionCard(
                icon: "circle.hexagongrid.fill",
                color: .yellow,
                title: "Fat",
                value: "\(record.totalFat) g"
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct NutritionCard: View {
    let icon: String
    let color: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.headline)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

// Food item component
struct FoodItemView: View {
    let food: FoodModel
    let quantity: Int
    
    
    var body: some View {
        HStack(spacing: 16) {
            Image(food.image)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.headline)
                
                Text("\(quantity) × Rp \(food.price)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack(spacing: 10) {
                    HStack(spacing: 3) {
                        Image(systemName: "circle.hexagongrid.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        Text("\(food.fat * quantity)g")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 1) {
                        Image(systemName: "bolt.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                        Text("\(food.protein * quantity)g")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 3) {
                        Image(systemName:"chart.pie.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("\(food.carbs * quantity)g")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 3)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName:"flame.fill")
                    .foregroundColor(.orange)
                    .font(.footnote)
                Text("\(food.calories * quantity) kcal")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 3)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
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
