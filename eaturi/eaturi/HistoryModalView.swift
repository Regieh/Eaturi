//
//  HistoryModalView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 21/03/25.
//

import SwiftUI

struct HistoryModalView: View {
    let historyItem: HistoryItem
    @Environment(\.presentationMode) var presentationMode
    
    let images = ["ayam_asam_manis", "mie_goreng", "telur_balado"]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                }
                
                Text(historyItem.title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(images, id: \.self) { imageName in
                        HStack {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(12)
                            
                            VStack(alignment: .leading) {
                                Text("Total: 360 Cal")
                                    .font(.headline)
                                Text("Protein: 40g")
                                    .font(.subheadline)
                                Text("Fiber: 10g")
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            Text("Rp. 25.000,-")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            
            HStack {
                Text("Total: 360 Cal")
                    .font(.headline)
                
                Spacer()
                
                Text("Rp. 25.000,-")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)
            }
            .padding()
            
            Button(action: {
                print("Add to cart")
            }) {
                Text("Add To Cart")
                    .font(.title3)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct HistoryModalView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryModalView(
            historyItem: HistoryItem(title: "11 Maret 2025", description: "🔥 500 Calorie", timestamp: "Rp. 25.000,-")
        )
    }
}
