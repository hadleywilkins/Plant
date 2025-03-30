//
//  UserData.swift
//  Plant
//
//  Created by redding sauter on 3/30/25.
//

import Foundation
import SwiftData

@Model
class UserData {
    // app stores all values in ounces, then converts by multiplying by UserData.unit
    var unit: Double = 1.0
    var goal: Int = 64
    var glassSize: Int = 8
    
    
    init() {
        
    }
    
    func setUnit(unit:String) {
        if (unit == "oz") {
            self.unit = 1.0
        } else if (unit == "l") {
            self.unit = 0.0295735
        }
    }
    
    func setGoal(goal:Int) {
        self.goal = goal
    }
    
    func setGlassSize(glassSize:Int) {
        self.glassSize = glassSize
    }
}
