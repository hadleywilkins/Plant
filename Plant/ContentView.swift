//
//  ContentView.swift
//  Plant
//
//  Created by redding sauter on 3/5/25.
//

import SwiftUI
import SwiftData

/// The main view that launches on startup
struct ContentView: View {
    @StateObject var hd = HydrationData()
    
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
                .environmentObject(hd)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            StatsView()
                .environmentObject(hd)
                .tabItem {
                    Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                }
                .modelContainer(container)

            SettingsView()
                .environmentObject(hd)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(PlantApp.colors.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
