//
//  Day.swift
//  Plant
//
//  Created by redding sauter on 4/5/25.
//
//stores day of water intake

import Foundation
import SwiftData

@Model
class WaterDay {
//    @Attribute(.unique)
    var date: String
    var goal: Double
    var intake: Double
    
    init(date: String, goal: Double, intake: Double) {
        self.goal = goal
        self.intake = intake
        self.date = date
    }
}
