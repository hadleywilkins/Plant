//
//  HydrationData.swift
//  Plant
//
//  Created by Hadley Wilkins on 3/26/25.
//

import SwiftUI

class HydrationData: ObservableObject {
    
    @AppStorage("waterIntake") var waterIntake: Int = 0
    @AppStorage("dailyGoal") var dailyGoal: Int = 8  // daily goal (in glasses)
    @AppStorage("unit") var unit: String = "oz"  // Default unit
    @AppStorage("glassSize") var glassSize: Double = 8.0

    let litersPerOz = 0.0295735

    func logGlassOfWater() {
        if waterIntake < dailyGoal {
            waterIntake += 1
            
//            defaults.set(waterIntake, forKey: "intake")
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
    
}
