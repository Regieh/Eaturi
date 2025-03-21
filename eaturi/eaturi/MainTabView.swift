//
//  MainTabView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 21/03/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Home")
                }

            HistoryView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("History")
                }
        }
    }
}

#Preview {
    MainTabView()
}
