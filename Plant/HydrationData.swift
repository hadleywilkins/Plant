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
    @AppStorage("unit") var unit: Unit = .ounces  // Default unit
    @AppStorage("glassSize") var glassSize: Double = 8.0

    let litersPerOz = 0.0295735
    
    // hd.unit.format(amountInMilliliters: hd.dailyGoal)
    
    enum Unit: String {
        case ounces = "oz"
        case liters = "L"
        
        func format(amountInMilliliters: Double) -> String {
            switch self {
                case .ounces:
                    return "\(amountInMilliliters / 1000.0) L"
                case .liters:
                    return "\(amountInMilliliters / 1234.0) oz"
            }
        }
        func format(amountInMilliliters: Double) -> Double {
            switch self {
                case .ounces:
                    return amountInMilliliters / 1000.0
                case .liters:
                    return amountInMilliliters / 1234.0
            }
        }
    }

    func logGlassOfWater() {
        if waterIntake < dailyGoal {
            waterIntake += 1
            
//            defaults.set(waterIntake, forKey: "intake")
        }
    }
    
    func updateDailyGoal(newGoal: Int) {
        dailyGoal = newGoal
    }
    
    func switchUnit(to newUnit: Unit) {
        unit = newUnit
    }
    
        func updateGlassSize(newSize: Double) {
            glassSize = newSize
        }

    func getTotalIntake() -> Double {
        let totalOz = Double(waterIntake) * glassSize
        // return unit == "oz" ? totalOz : totalOz * litersPerOz
        
        return unit.format(amountInMilliliters: totalOz)
    }

    func getDailyGoal() -> Double {
        let goalOz = Double(dailyGoal) * glassSize
        // return unit == "oz" ? goalOz : goalOz * litersPerOz
        return unit.format(amountInMilliliters: goalOz)
    }

    func resetDailyIntake() {
        waterIntake = 0
    }
    
}
