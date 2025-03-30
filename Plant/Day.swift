//
//  Day.swift
//  Plant
//
//  Created by redding sauter on 3/30/25.
//

import Foundation
import SwiftData

@Model
class Day {
    @Attribute(.unique) var date = Date()
    var goal: Int
    var intake: Int
    
    init(goal: Int) {
        self.goal = goal
        self.intake = 0
    }
    
    func updateIntake(amount: Int) {
        self.intake += amount
    }
}
