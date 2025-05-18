//
//  PopularCardView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//
import SwiftUI

struct PopularCardView: View {
    let isAvailable: Bool
    @Binding var item: FoodModel

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background image
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()
                .cornerRadius(20)

            // Overlay gradient (optional for text readability)
            LinearGradient(
                gradient: Gradient(colors: [Color("colorOren").opacity(1), Color("colorOren").opacity(0.3), Color("colorOren").opacity(0)]),
                startPoint: .bottom,
                endPoint: .top
            )
            .cornerRadius(20)
            
            Rectangle()
                  .fill(Color("colorOren"))
                  .frame(height: 50)

            // Text overlay
            HStack {
                Text(item.name)
                    .font(.title3)
                    .foregroundColor(.white)
                    .lineLimit(1)

                Spacer()

                Text("\(item.calories) Kcal")
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(height: 150)
            .grayscale(isAvailable ? 0 : 1)
            .opacity(isAvailable ? 1 : 0.7)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
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
