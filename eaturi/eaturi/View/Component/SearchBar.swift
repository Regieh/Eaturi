import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @State private var isExpanded = false
    @Binding var isFilterModalPresented: Bool
    @Binding var selectedFilters: [String]
    
    var body: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.gray)
                    .accentColor(Color("colorPrimary"))
                
                
                if !searchText.isEmpty {
                    Button(action: {
                        withAnimation {
                            searchText = ""
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .transition(.opacity)
                }
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isFilterModalPresented.toggle()
                }
            }) {
                Image(systemName: "slider.vertical.3")
                    .foregroundColor(.white)
                    .symbolVariant(.fill)
                    .font(.system(size: 26, weight: .bold))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .background(Color("colorOren"))
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isFilterModalPresented) {
                FilterView(
                    onSelectFilter: { filters in
                        self.selectedFilters = filters
                        isFilterModalPresented = false
                    },
                    selectedFilters: selectedFilters
                )
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
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

