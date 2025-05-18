//
//  ResultFilterBar.swift
//  eaturi
//
//  Created by Flavia Angelina Witarsah on 16/05/25.
//

import SwiftUI

struct ResultFilterBar: View {
    @Binding var selectedFilters: [String]
    var onRemoveFilter: ((String) -> Void)? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(selectedFilters, id: \.self) { filter in
                    HStack(spacing: 4) {
                        Text(filter)
                            .font(.subheadline)
                            .foregroundColor(Color("colorOren"))
                            .cornerRadius(20)
                        
                        Button(action: {
                            // Remove the filter directly here
                            if let index = selectedFilters.firstIndex(of: filter) {
                                selectedFilters.remove(at: index)
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.body)
                                .foregroundColor(Color("colorOren"))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    Color.white
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color("colorOren"), lineWidth: 2)
                        )
                )
                .padding(.horizontal, 8)
                .frame(height: 40)
            }
        }
        .padding(.horizontal, 15)
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

