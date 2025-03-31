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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
//        .modelContainer(for: [Day.self, UserData.self])
        .modelContainer(for: Day.self)
    }
}
