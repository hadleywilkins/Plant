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
        NavigationView {
            Form {
                Section(header: Text("Hydration Goal")) {
                    Stepper("Daily Goal: \(hydrationData.dailyGoal) glasses", value: $hydrationData.dailyGoal, in: 4...20, step: 1)
                        Text("Set your daily water intake goal based on your needs.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }

                Section(header: Text("Measurement Units")) {
                    Picker("Unit", selection: $hydrationData.unit) {
                        Text("Ounces (oz)").tag("oz")
                            Text("Liters (L)").tag("L")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                    if (hydrationData.unit == "oz") {
                        Stepper("Glass Size: \(String(format: "%.1f", hydrationData.glassSize)) oz",
                                value: $hydrationData.glassSize, in: 4...32, step: 2)
                        Text("Adjust the size of a single glass of water (in ounces).")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    if (hydrationData.unit == "L") {
                        Stepper("Glass Size: \(String(format: "%.1f", hydrationData.glassSize)) L",
                                value: $hydrationData.glassSize, in: 0.25 ... 2, step: 0.25)
                        Text("Adjust the size of a single glass of water (in ounces).")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    }
                        
                    }
                    .navigationTitle("Settings")
                }
            }
        }

