//
//  HydrationData.swift
//  Plant
//
//  Created by Hadley Wilkins on 3/26/25.
//

import SwiftUI
import SwiftData

class HydrationData: ObservableObject {
    @Environment(\.modelContext) private var context
    
    // @Query(sort: \Day.date) var days: [Day]
    @Query var days: [Day]
    // @Query var user: [UserData]
    
    @Published var waterIntake: Int = 0  // water consumed (in glasses)
    @Published var dailyGoal: Int = 8  // daily goal (in glasses)
    @Published var unit: String = "oz"  // Default unit
    @Published var glassSize: Double = 8.0
    
    init() {
//        if(user.isEmpty) {
//            createUser()
//        }
        addDay()
        waterIntake = days.first!.intake
    }

    let litersPerOz = 0.0295735

    func logGlassOfWater() {
        if waterIntake < dailyGoal {
            waterIntake += 1
        }
    }
    
    func updateDailyGoal(newGoal: Int) {
        dailyGoal = newGoal
    }
    
    func switchUnit(to newUnit: String) {
        unit = newUnit
    }
    
        func updateGlassSize(newSize: Double) {
            glassSize = newSize
        }

    func getTotalIntake() -> Double {
        let totalOz = Double(waterIntake) * glassSize
        return unit == "oz" ? totalOz : totalOz * litersPerOz
    }

    func getDailyGoal() -> Double {
        let goalOz = Double(dailyGoal) * glassSize
        return unit == "oz" ? goalOz : goalOz * litersPerOz
    }

    func resetDailyIntake() {
        waterIntake = 0
    }
    
//    func createUser() {
//        let user = UserData()
//        context.insert(user)
//    }
    
//    func addDay(user: UserData) {
    func addDay() {
//        let goal = user.goal
        let day = Day(goal:64)
        context.insert(day)
    }
}
