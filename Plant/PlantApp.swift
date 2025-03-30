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
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Day.date) var days: [Day]
    @Query var user: [UserData]
    init() {
        if(user.isEmpty) {
            createUser()
        }
        if(days.isEmpty) {
            addDay(user:user[0])
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Day.self, UserData.self])
    }
    
    func createUser() {
        let user = UserData()
        context.insert(user)
    }
    
    func addDay(user: UserData) {
        let goal = user.goal
        let day = Day(goal:goal)
        context.insert(day)
    }
}
