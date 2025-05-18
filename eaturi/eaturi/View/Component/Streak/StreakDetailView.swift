//
//  StreakDetailView.swift
//  eaturi
//
//  Created by Flavia Angelina Witarsah on 18/05/25.
//

import SwiftUI

struct StreakDetailView: View {
    // MARK: – Inputs
    var streakCount: Int = 5
    /// Index of the current weekday (0 = Sunday … 6 = Saturday)
    var currentWeekday: Int = Calendar.current.component(.weekday, from: .now) - 1
    
    // MARK: – Styling helpers
    private var background: some View {
        Color("colorBackground")
            .edgesIgnoringSafeArea(.all)
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
               background
                
                // Main content
                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        FlameWithNumber(count: streakCount, accent: .orange)
                        Text("day streak!")
                            .font(.title2.weight(.semibold))
                            .foregroundColor(Color.black)
                    }
                    WeekRow(streakCount: streakCount,
                            currentWeekday: currentWeekday,
                            accent: .orange,
                            stroke: .orange)
                    
                    Text("Logged your meal and\nkept your ***streak*** alive!")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 24)
                        .font(.body.weight(.medium))
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("I got it!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 50)
                            .background(Color("colorPrimary"))
                            .cornerRadius(100)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                .padding(.top, 64)
            }
            .navigationBarHidden(true)
            .presentationDetents([.fraction(0.999)])
            .presentationDragIndicator(.hidden)
        }
    }
    
    // MARK: – Helpers
    @Environment(\.dismiss) private var dismiss
}

// MARK: – Flame + Big Number
private struct FlameWithNumber: View {
    var count: Int
    var accent: Color
    
    var body: some View {
        VStack {
            // custom flame shape → stretched SF Symbol w/ overlay works fine
            Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.orange)
            
            Text("\(count)")
                .font(.system(size: 96, weight: .bold))
                .foregroundColor(.orange)
                .padding(.bottom, 6)
        }
    }
}

// MARK: – Week row
private struct WeekRow: View {
    var streakCount: Int
    var currentWeekday: Int
    var accent: Color
    var stroke: Color
    
    private let days = Calendar.current.shortWeekdaySymbols // ["Sun","Mon",…]
    
    var body: some View {
        VStack(spacing: 12) {
            // day labels + circles
            HStack(spacing: 16) {
                ForEach(0..<7, id: \.self) { index in
                    VStack(spacing: 4) {
                        Text(String(days[index].prefix(1)))          // Su, M, T …
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(
                                index <= currentWeekday ? .orange : .orange.opacity(0.35)
                            )
                        
                        ZStack {
                            Circle()
                                .fill(index < streakCount ? accent : .clear)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(stroke, lineWidth: 1)
                                )
                            
                            if index < streakCount {
                                Image(systemName: "checkmark")
                                    .font(.caption.weight(.bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(stroke, lineWidth: 2)
        )
        .padding(.horizontal, 24)
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

