//
//  Day.swift
//  Plant
//
//  Created by redding sauter on 4/5/25.
//

import Foundation
import SwiftData

@Model
class WaterDay {
    // TODO: figure out how the Date() class works
//    @Attribute(.unique)
    var date: Date
    var goal: Double
    var intake: Double
    
    init(date: Date, goal: Double, intake: Double) {
        self.goal = goal
        self.intake = intake
        self.date = date
    }
}
