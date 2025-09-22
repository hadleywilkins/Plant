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
        
        var coarseGrain: Double {
            switch self {
                case .ounces: return 8
                case .liters: return 0.5
            }
        }
        
        var fineGrain: Double {
            switch self {
                case .ounces: return 2
                case .liters: return 0.25
            }
        }
        
        func format(amountInMilliliters: Double, grainCoarse: Bool) -> String {
            switch self {
                case .ounces:
                return "\(String(format: "%.1f", roundValue(amountInMilliliters: amountInMilliliters, grainCoarse: grainCoarse))) oz"
                case .liters:
                    return "\(String(format: "%.2f", roundValue(amountInMilliliters: amountInMilliliters, grainCoarse: grainCoarse))) L"
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
        
        func roundValue(amountInMilliliters: Double, grainCoarse: Bool) -> Double {
            let raw = value(amountInMilliliters: amountInMilliliters)
            let grain = grainCoarse ? coarseGrain : fineGrain
            return round(raw / grain) * grain
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
        return unit.format(amountInMilliliters: waterIntake, grainCoarse: false)
        }

    func getDailyGoalFormatted() -> String {
            return unit.format(amountInMilliliters: dailyGoal, grainCoarse: true )
        }
    
    func getGlassSizeFormatted() -> String {
            return unit.format(amountInMilliliters: glassSize, grainCoarse: false )
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
