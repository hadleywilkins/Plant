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
                    //Stepper gets a little weird when adjusting units until back in base values, not sure how to fix/if needed at this point
                    Stepper("Daily Goal: \(hydrationData.unit.format(amountInMilliliters: hydrationData.dailyGoal))",
                            value: Binding(
                                get: {hydrationData.unit.value(amountInMilliliters: hydrationData.dailyGoal)
                                },
                                set: { newValue in
                                    let newGoalInML = hydrationData.unit == .ounces ? newValue * 29.5735 : newValue * 1000
                                    hydrationData.updateDailyGoal(newGoal: newGoalInML)
                                }
                            ),
                            in: hydrationData.unit == .ounces ? 32...160 : 1...5,
                            step: hydrationData.unit == .ounces ? 8 : 0.25
                    )
                    Text("Set your daily water intake goal based on your needs.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Section(header: Text("Measurement Units")) {
                    Picker("Unit", selection: $hydrationData.unit) {
                        Text("Ounces (oz)").tag(HydrationData.Unit.ounces)
                        Text("Liters (L)").tag(HydrationData.Unit.liters)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Stepper("Glass Size: \(hydrationData.unit.format(amountInMilliliters: hydrationData.glassSize))",
                            value: Binding(
                                get: {
                                    hydrationData.unit.value(amountInMilliliters: hydrationData.glassSize)
                                },
                                set: { newValue in
                                    let newSizeInML = hydrationData.unit == .ounces ? newValue * 29.5735 : newValue * 1000
                                    hydrationData.updateGlassSize(newSize: newSizeInML)
                                }
                            ),
                            in: hydrationData.unit == .ounces ? 4...32 : 0.25...2,
                            step: hydrationData.unit == .ounces ? 2 : 0.25
                    )
                    
                    Text("Adjust the size of a single glass of water.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Settings")
        }
    }
}


