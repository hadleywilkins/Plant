//
//  SettingsView.swift
//  Plant
//
//  Created by redding sauter on 3/10/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var hydrationData: HydrationData

    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Update Your Daily Hydration Goal")
                .font(.headline)

            Stepper("Daily Goal: \(hydrationData.dailyGoal) glasses", value: $hydrationData.dailyGoal, in: 4...20, step: 1)

            Text("Adjust your goal based on your hydration needs.")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Picker("Measurement Unit", selection: $hydrationData.unit) {
                            Text("Ounces (oz)").tag("oz")
                            Text("Liters (L)").tag("L")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
            
            // Glass Size Adjustment
            Stepper("Glass Size: \(String(format: "%.1f", hydrationData.glassSize)) \(hydrationData.unit)", value: $hydrationData.glassSize, in: 4...32, step: 2)
                    .padding()

            Text("Adjust the size of a single glass of water.")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
    }
}
