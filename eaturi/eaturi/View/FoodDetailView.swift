import SwiftUI

struct FoodDetailView: View {
    // MARK: - Properties
    let item: FoodModel
    let isAvailableToday: Bool
    
    @Binding var isPresented: Bool
    @Binding var cartItems: [UUID: Int]
    @Binding var isCartVisible: Bool
    @Binding var showDetailModal: Bool
    
    @State private var quantity: Int = 1
    @State private var initialQuantity: Int = 1
    @State private var selectedServingSize: String = "1 serving"
    
    // MARK: - Initialization
    init(item: FoodModel,
         isPresented: Binding<Bool>,
         cartItems: Binding<[UUID: Int]>,
         isCartVisible: Binding<Bool>,
         showDetailModal: Binding<Bool>,
         isAvailableToday: Bool) {
        self.item = item
        _isPresented = isPresented
        _cartItems = cartItems
        _isCartVisible = isCartVisible
        _showDetailModal = showDetailModal
        self.isAvailableToday = isAvailableToday
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            foodImageView
            detailsSection
            nutritionSection
            servingSizeSelection
            actionButtons
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 6)
        .cornerRadius(20)
        .background(Color("colorBackground")).edgesIgnoringSafeArea(.all)
        .onTapGesture {
            isPresented = false
            showDetailModal = false
        }
        .onAppear {
            let initialValue = cartItems[item.id] ?? 1
            quantity = initialValue
            initialQuantity = initialValue
        }
        .grayscale(isAvailableToday ? 0 : 1)
        .opacity(isAvailableToday ? 1 : 0.7)
    }
    
    // MARK: - Computed Nutrition Values
    private var adjustedCalories: Int {
        selectedServingSize == "1 serving" ? item.calories : item.calories / 2
    }
    private var adjustedFat: Double {
        selectedServingSize == "1 serving" ? Double(item.fat) : Double(item.fat) / 2
    }
    private var adjustedProtein: Double {
        selectedServingSize == "1 serving" ? Double(item.protein) : Double(item.protein) / 2
    }
    private var adjustedCarbs: Double {
        selectedServingSize == "1 serving" ? Double(item.carbs) : Double(item.carbs) / 2
    }
    private var adjustedFiber: Double {
        selectedServingSize == "1 serving" ? Double(item.fiber) : Double(item.fiber) / 2
    }
    
    // MARK: - Subviews
    private var foodImageView: some View {
        GeometryReader { geometry in
            Image(item.image)
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width * 0.98, height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.top, 20)
                .position(x: geometry.size.width / 2, y: 240 / 2 + 20)
                .saturation(isAvailableToday ? 1 : 0)
                .opacity(isAvailableToday ? 1 : 0.5)
        }
        .frame(height: 260)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.newblek)
            
            Text(item.foodDescription)
                .font(.body)
                .foregroundStyle(.abu)
        }
    }
    
    private var nutritionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nutrition")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.newblek)
            
            HStack(spacing: 4) {
                Text("Calories")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                Spacer()
                Text("\(adjustedCalories)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(15)
            
            HStack(spacing: 10) {
                nutritionItem(
                    icon: "drop.fill",
                    value: "\(adjustedFat.clean)g",
                    label: "Fat",
                    bgColor: Color.blue.opacity(0.1),
                    textColor: .blue
                )
                nutritionItem(
                    icon: "fish.fill",
                    value: "\(adjustedProtein.clean)g",
                    label: "Protein",
                    bgColor: Color.red.opacity(0.1),
                    textColor: .red
                    )
                nutritionItem(
                    icon: "laurel.trailing",
                    value: "\(adjustedCarbs.clean)g",
                    label: "Carbs",
                    bgColor: Color.yellow.opacity(0.1),
                    textColor: .orange
                )

                nutritionItem(
                    icon: "leaf.fill",
                    value: "\(adjustedFiber.clean)g",
                    label: "Fiber",
                    bgColor: Color.green.opacity(0.1),
                    textColor: .green
                )

            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 10) {
            if isAvailableToday {
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
                    buttonSize: 35,
                    iconSize: 15,
                    fontSize: 25
                )
                .padding(.vertical, 10)
                .foregroundStyle(Color.black)
                
                Button(action: addToCart) {
                    Text(buttonText)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 50)
                        .background(quantity > 0 ? Color.colorPrimary : Color.gray)
                        .cornerRadius(100)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
                .disabled(quantity <= 0)
            } else {
                Button(action: {}) {
                    Text("Not Available Today")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.gray)
                        .cornerRadius(100)
                }
                .disabled(true)
            }
        }
        .padding(.bottom, 20)
    }
    
    private var buttonText: String {
        if initialQuantity >= 0 && quantity != initialQuantity {
            return "Add this food"
        } else {
            return "Add this food"
        }
    }
    
    // MARK: - Helper Methods
    private func addToCart() {
        if quantity > 0 {
            cartItems[item.id] = quantity
            isCartVisible = true
        } else {
            cartItems.removeValue(forKey: item.id)
        }
        isPresented = false
        showDetailModal = false
    }
    
    @ViewBuilder
    private func nutritionItem(icon: String, value: String, label: String, bgColor: Color, textColor: Color) -> some View {
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
    
    // MARK: - Serving Size Selection
    private var servingSizeSelection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Serving Size")
                .font(.body)
                .foregroundStyle(.newblek)
                .padding(.bottom, 4)

            VStack(spacing: 0) {
                radioButton(id: "1 serving", label: "1 Serving", value: "50g")
                Divider()
                radioButton(id: "1/2 serving", label: "1/2 Serving", value: "25g")
            }
            .background(Color(.systemGroupedBackground))
            .cornerRadius(12)
        }
        .padding(.top, 10)
        .disabled(!isAvailableToday) 
    }

    @ViewBuilder
    private func radioButton(id: String, label: String, value: String) -> some View {
        Button(action: {
            withAnimation {
                selectedServingSize = id
            }
        }) {
            HStack {
                Image(systemName: selectedServingSize == id ? "largecircle.fill.circle" : "circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)

                Text(label)
                    .font(.body)
                    .foregroundColor(.primary)

                Spacer()

                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.white)
    }
}

// MARK: - Extension for clean number formatting
extension Double {
    var clean: String {
        return truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", self)
            : String(format: "%.1f", self)
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
