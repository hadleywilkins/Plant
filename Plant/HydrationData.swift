//
//  HydrationData.swift
//  Plant
//
//  Created by Hadley Wilkins on 3/26/25.
//

import SwiftUI

class HydrationData: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var waterIntake: Int  // water consumed (in glasses)
//    @AppStorage("waterIntake", store: UserDefaults(suiteName: "group.reddingSauter.Plant"))
//        var waterIntake: Int = 0
    @Published var dailyGoal: Int  // daily goal (in glasses)
    @Published var unit: String  // Default unit
    @Published var glassSize: Double
    
    init() {
        // if none, defaults to 0. perfect in this case
        waterIntake = defaults.integer(forKey: "intake")
        dailyGoal = (defaults.integer(forKey: "goal") != 0) ? defaults.integer(forKey: "goal") : 8
        unit = (defaults.string(forKey: "unit") != nil) ? defaults.string(forKey: "unit")! : "oz"
        glassSize = (defaults.double(forKey: "glassSize") != 0) ? defaults.double(forKey: "glassSize") : 8.0
    }
    

    let litersPerOz = 0.0295735

    func logGlassOfWater() {
        if waterIntake < dailyGoal {
            waterIntake += 1
            
            defaults.set(waterIntake, forKey: "intake")
        }
    }
    
    func updateDailyGoal(newGoal: Int) {
        dailyGoal = newGoal
        
        defaults.set(dailyGoal, forKey: "goal")
    }
    
    func switchUnit(to newUnit: String) {
        unit = newUnit
        
        defaults.set(unit, forKey: "unit")
    }
    
        func updateGlassSize(newSize: Double) {
            glassSize = newSize
            
            defaults.set(glassSize, forKey: "glassSize")
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
        
        defaults.set(waterIntake, forKey: "intake")
    }
    
}
