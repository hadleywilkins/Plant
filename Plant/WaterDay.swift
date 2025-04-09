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
    var date: String
    var goal: Int
    var intake: Int
    
    init(date: String, goal: Int, intake: Int) {
        self.goal = goal
        self.intake = intake
        self.date = date
    }
}
