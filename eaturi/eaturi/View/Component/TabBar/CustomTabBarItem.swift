//
//  CustomTabBarItem.swift
//  eaturi
//
//  Created by Raphael Gregorius on 08/04/25.
//

import SwiftUI

struct CustomTabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? color : .gray)

            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? color : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}
