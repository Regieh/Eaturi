import SwiftUI
import SwiftData

struct MainTabView: View {
    // MARK: - Environment
    @EnvironmentObject var streakManager: StreakManager
    
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \FoodModel.name) private var foodItems: [FoodModel]
    
    @State private var selectedTab = 0
    @State var cartItems: [UUID: Int]
    @State var isCartVisible: Bool = false
    @State private var showSplash = true
    @State private var shouldNavigateToCart = false  // Add this state variable
    
    var body: some View {
        Group {
            NavigationStack {
                VStack {
                    ZStack {
                        switch selectedTab {
                        case 0:
                            ContentView(
                                cartItems: $cartItems,
                                isCartVisible: $isCartVisible,
                                foodItems: .constant(foodItems),
                                selectedTab: $selectedTab,
                                shouldNavigateToCart: $shouldNavigateToCart  // Pass this binding
                            )
                            .environment(\.modelContext, modelContext)
                            
                        case 1:
                            HistoryView(
                                onPickAgain: { selectedCart in                 // (same closure)
                                    cartItems = selectedCart
                                    isCartVisible = true
                                    selectedTab = 0
                                    shouldNavigateToCart = true
                                }
                            )
                            .environment(\.modelContext, modelContext)
                            
                            
                        default:
                            EmptyView()
                        }
                    }
                    HStack(spacing: 0) {
                        Button {
                            selectedTab = 0
                        } label: {
                            CustomTabBarItem(icon: "fork.knife", title: "Menu", isSelected: selectedTab == 0, color: Color("colorPrimary"))
                        }
                        
                        Button {
                            selectedTab = 1
                        } label: {
                            CustomTabBarItem(icon: "list.bullet.clipboard", title: "History", isSelected: selectedTab == 1, color: Color("colorPrimary"))
                        }
                    }
                    .frame(height: 60)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: -2)
                    .safeAreaInset(edge: .bottom) {
                        Color.white.frame(height: 10)
                    }
                    }
                    .ignoresSafeArea(.all)
                    .preferredColorScheme(.light)
                    .navigationDestination(isPresented: $shouldNavigateToCart) {
                        CartView(
                            cartItems: $cartItems,
                            foodItems: foodItems,
                            selectedTab: $selectedTab
                        )
                    }
                }
                .ignoresSafeArea(.keyboard)
                .ignoresSafeArea(.container, edges: .top)
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
