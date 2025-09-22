//
//  HydrationData.swift
//  Plant
//
//  Created by Hadley Wilkins on 3/26/25.
//

import SwiftUI
import WidgetKit

/// Info about current goal and hydration progress
class HydrationData: ObservableObject {
    
    // you may have to change this (here and in PlantWidget) to run on your account!
    let widgetData = UserDefaults(suiteName: "group.com.resariha.plantwidget")
    
    @AppStorage("waterIntake") var waterIntake: Double = 0 //Store in mL
    @AppStorage("dailyGoal") var dailyGoal: Double = 2000  // daily goal (in mL)
    @AppStorage("unit") var unit: Unit = .ounces  // Default unit
    @AppStorage("glassSize") var glassSize: Double = 250 // Default glass size in mL
    
    enum Unit: String {
        case ounces = "oz"
        case liters = "L"
        
        //refactor to use bool fineGrain true or false once functional
        func format(amountInMilliliters: Double, ounceRound: Double, literRound: Double) -> String {
            switch self {
                case .ounces:
                return "\(String(format: "%.1f", roundValue(amountInMilliliters: amountInMilliliters, ounceRound: ounceRound, literRound: literRound))) oz"
                case .liters:
                    return "\(String(format: "%.2f", roundValue(amountInMilliliters: amountInMilliliters, ounceRound: ounceRound, literRound: literRound))) L"
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
        
        func roundValue(amountInMilliliters: Double, ounceRound: Double, literRound: Double) -> Double {
            switch self {
                case .ounces:
                    return (round(value(amountInMilliliters: amountInMilliliters) / ounceRound) * ounceRound)
                case .liters:
                    return (round(value(amountInMilliliters: amountInMilliliters) / literRound) * literRound)
            }
        }
        
    }

    func logGlassOfWater() {
        if waterIntake < dailyGoal { //if glass bigger than amount of water remaining, won't log
            waterIntake += glassSize
        }
        if waterIntake > dailyGoal{
            waterIntake = dailyGoal
        }
        syncToWidget()
    }
    
    func updateDailyGoal(newGoal: Double) {
        dailyGoal = newGoal
        syncToWidget()
    }
    
    func switchUnit(to newUnit: Unit) {
        unit = newUnit
    }
    
    func updateGlassSize(newSize: Double) {
        glassSize = newSize
    }
    
    func getTotalIntakeFormatted() -> String {
        return unit.format(amountInMilliliters: waterIntake, ounceRound: 2, literRound: 0.25)
        }

    func getDailyGoalFormatted() -> String {
            return unit.format(amountInMilliliters: dailyGoal, ounceRound: 8, literRound: 0.5 )
        }
    
    func getGlassSizeFormatted() -> String {
            return unit.format(amountInMilliliters: glassSize, ounceRound: 2, literRound: 0.25 )
        }

    func resetDailyIntake() {
        waterIntake = 0
        syncToWidget()
    }
    
    func syncToWidget() {
        widgetData?.set(waterIntake, forKey: "waterIntake")
        widgetData?.set(dailyGoal, forKey: "dailyGoal")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
}
