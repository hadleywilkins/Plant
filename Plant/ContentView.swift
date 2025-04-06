//
//  ContentView.swift
//  Plant
//
//  Created by redding sauter on 3/5/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var hydrationData = HydrationData()
    private var container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: WaterDay.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
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
                .modelContainer(container)

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
