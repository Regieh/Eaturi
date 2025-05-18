//
//  StreakBadge.swift
//  eaturi
//
//  Created by Flavia Angelina Witarsah on 18/05/25.
//


import SwiftUI

struct StreakBadge: View {
    /// Number of consecutive days
    var count: Int
    
    var body: some View {
        HStack(spacing: 4) {
            // SF Symbol ≈ the orange flame used in most calorie apps
            Image(systemName: "flame.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.orange)
                // keep it tiny so icon + number fit comfortably
            Text("\(count)")
                .font(.headline.weight(.semibold))
                .foregroundColor(.orange)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 8)
        .background(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.orange, lineWidth: 1.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 1, y: 1) // subtle lift
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
