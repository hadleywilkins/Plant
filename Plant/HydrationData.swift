//
//  HydrationData.swift
//  Plant
//
//  Created by Hadley Wilkins on 3/26/25.
//

import SwiftUI

class HydrationData: ObservableObject {
    @Published var waterIntake: Int = 0  // water consumed (in glasses)
    let dailyGoal: Int = 8  // daily goal (in glasses)

    func logGlassOfWater() {
        if waterIntake < dailyGoal {
            waterIntake += 1
        }
    }
}
