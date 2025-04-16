//
//  HydrationData.swift
//  Plant
//
//  Created by Hadley Wilkins on 3/26/25.
//

import SwiftUI

class HydrationData: ObservableObject {
    
    @AppStorage("waterIntake") var waterIntake: Double = 0 //Store in mL
    @AppStorage("dailyGoal") var dailyGoal: Double = 2000  // daily goal (in mL)
    @AppStorage("unit") var unit: Unit = .ounces  // Default unit
    @AppStorage("glassSize") var glassSize: Double = 250 // Default glass size in mL
    
    // hd.unit.format(amountInMilliliters: hd.dailyGoal)
    
    enum Unit: String {
        case ounces = "oz"
        case liters = "L"

        func format(amountInMilliliters: Double) -> String {
            switch self {
                case .liters:
                    let liters = amountInMilliliters / 1000
                    return "\(String(format: "%.2f", liters)) L"
                case .ounces:
                    let ounces = amountInMilliliters / 29.5735
                    return "\(String(format: "%.1f", ounces)) oz"
            }
        }
        func value(amountInMilliliters: Double) -> Double {
            switch self {
                case .ounces:
                    return amountInMilliliters / 29.5735
                case .liters:
                    return amountInMilliliters / 1000.0
            }
        }
        
        func roundForDisplay(amountInMilliliters: Double, ounceRound: Double, literRound: Double) -> Double {
            switch self {
                case .ounces:
                    return (round(value(amountInMilliliters: amountInMilliliters) / ounceRound) * ounceRound)
                case .liters:
                    return (round(value(amountInMilliliters: amountInMilliliters) / literRound) * literRound)
            }
        }
        
    }

    func logGlassOfWater() {
        if waterIntake < dailyGoal {
            waterIntake += glassSize
            
//            defaults.set(waterIntake, forKey: "intake")
        }
    }
    
    func updateDailyGoal(newGoal: Double) {
        dailyGoal = newGoal
    }
    
    func switchUnit(to newUnit: Unit) {
        unit = newUnit
    }
    
    func updateGlassSize(newSize: Double) {
        glassSize = newSize
    }

    func getTotalIntakeFormatted() -> String {
        return unit.format(amountInMilliliters: waterIntake)
    }

    func getDailyGoalFormatted() -> String {
        return unit.format(amountInMilliliters: dailyGoal)
    }

    func resetDailyIntake() {
        waterIntake = 0
    }
    
}
