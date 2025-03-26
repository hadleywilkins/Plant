//
//  StatsView.swift
//  Plant
//
//  Created by Hadley Wilkins on 3/26/25.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var hydrationData: HydrationData
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hydration Stats")
                .font(.largeTitle)
                .fontWeight(.bold)

        ProgressView(value: Double(hydrationData.waterIntake), total: Double(hydrationData.dailyGoal))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(width: 250)

        Text("\(hydrationData.waterIntake) / \(hydrationData.dailyGoal) glasses")
                .font(.subheadline)
                .foregroundColor(.gray)

        }
    }
}
