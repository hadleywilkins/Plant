//
//  ContentView.swift
//  Plant
//
//  Created by redding sauter on 3/5/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var hydrationData = HydrationData()
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(hydrationData)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            StatsView()
                .environmentObject(hydrationData)
                .tabItem {
                    Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                }

            SettingsView()
                .environmentObject(hydrationData)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
