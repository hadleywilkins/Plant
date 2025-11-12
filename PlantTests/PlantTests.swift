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

    @Test func testOuncesRounding() async throws {
        
        let hd = HydrationData()
//        hd.resetDailyIntake()
//        let testCase = HydrationData.Unit.ounces
        HydrationData().waterIntake = 0
        let result = hd.getTotalIntakeFormatted()
        #expect(result == "0.0 oz")
        
    }
    
    deinit {
        HydrationData().waterIntake = waterIntake
        HydrationData().dailyGoal = dailyGoal
        HydrationData().glassSize = glassSize
        HydrationData().unit = unit
        
    }
}
