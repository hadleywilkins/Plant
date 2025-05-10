//
//  Day.swift
//  Plant
//
//  Created by redding sauter on 4/5/25.
//

import Foundation
import SwiftData

/// stores a past day's hydration data
@Model
class WaterDay {
    var date: Date
    var goal: Double
    var intake: Double
    
    init(date: Date, goal: Double, intake: Double) {
        self.goal = goal
        self.intake = intake
        self.date = date
    }
}
