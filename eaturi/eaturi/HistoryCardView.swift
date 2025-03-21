//
//  HistoryCardView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 21/03/25.
//

import SwiftUI

struct HistoryCardView: View {
    let historyItem: HistoryItem
    @Binding var showModal: HistoryItem?
    
    let images = ["ayam_asam_manis", "mie_goreng", "telur_balado"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(historyItem.title)
                .font(.headline)
                .foregroundColor(.black)
            
            HStack {
                ForEach(images, id: \.self) { imageName in
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                }
            }
            .padding(.vertical, 8)
            
            Text(historyItem.description)
                .font(.subheadline)
                .foregroundColor(.black)
            
            HStack {
                Spacer()
                Text(historyItem.timestamp)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.black)
            }
            
            Button(action: {
                showModal = historyItem
            }) {
                Text("Pilih Lagi")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.3), lineWidth: 2))
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

struct HistoryCardView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryCardView(
            historyItem: HistoryItem(title: "11 Maret 2025", description: "🔥 500 Calorie", timestamp: "Rp. 25.000,-"),
            showModal: .constant(nil)
        )
    }
}
