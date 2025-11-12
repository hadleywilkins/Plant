//
//  PlantTests.swift
//  PlantTests
//
//  Created by redding sauter on 3/5/25.
//

import Testing
@testable import Plant
//@testable import HydrationData.Unit
import SwiftUI

class PlantTests {
    var waterIntake: Double
    var dailyGoal: Double
    var unit : HydrationData.Unit
    var glassSize: Double
    
    init() async throws {
        waterIntake = HydrationData().waterIntake
        dailyGoal = HydrationData().dailyGoal
        unit = HydrationData().unit
        glassSize = HydrationData().glassSize
        
    }
    
    @Test func testUnitConversion() async throws {
        let testCase = HydrationData.Unit.liters
        let result = testCase.value(amountInMilliliters: 100)
        #expect(result == 0.1)
        
        let testCase2 = HydrationData.Unit.ounces
        let result2 = testCase2.value(amountInMilliliters: 100)
        #expect(result2 == 3.381405650328842)
    }

    @Test func testGetTotalIntakeFormatted() async throws {
        
        let hd = HydrationData()
        
        let dailyGoal_oz = 64.0
        let glassSize_oz = 8.0
        
        hd.waterIntake = 0
        hd.dailyGoal = 1892.71 //64 oz in mL
        hd.unit = HydrationData.Unit.ounces
        hd.glassSize = 236.588 //8 oz in mL
        
        var expected = 0.0
        var expected_str = "0.0 oz"
        #expect(hd.getTotalIntakeFormatted() == expected_str)
        

        
        repeat {
            hd.logGlassOfWater()
            expected += glassSize_oz
            if (expected > dailyGoal_oz) {
                expected = dailyGoal_oz
            }
            expected_str = "\(String(format: "%.1f", expected)) oz"
            #expect(hd.getTotalIntakeFormatted() == expected_str)
        } while expected < dailyGoal_oz
        
    }
    
    deinit {
        HydrationData().waterIntake = waterIntake
        HydrationData().dailyGoal = dailyGoal
        HydrationData().glassSize = glassSize
        HydrationData().unit = unit
        
    }
}
