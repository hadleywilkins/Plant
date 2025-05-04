//
//  PlantApp.swift
//  Plant
//
//  Created by redding sauter on 3/5/25.
//

import SwiftUI
import SwiftData

@main
struct PlantApp: App {
    // seeding from oklch(0.71 0.1608 120.52), which is a brighter version of the leaf color
    public struct colors {
        static let blue = Color.oklch(0.71, 0.1608, .degrees(245.16))
        static let red = Color.oklch(0.71, 0.1608, .degrees(22.97))
        static let green = Color.oklch(0.71, 0.1608, .degrees(120.52))
        static let tan = Color.oklch(0.71, 0.0642, .degrees(68.9))
        static let brown = Color.oklch(0.49, 0.0642, .degrees(68.9))
        static let darkbrown = Color.oklch(0.32, 0.0642, .degrees(68.9))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: WaterDay.self)
    }
}
