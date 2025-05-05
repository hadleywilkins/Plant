//
//  SettingsView.swift
//  Plant
//
//  Created by redding sauter on 3/10/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var hd: HydrationData
    
    var body: some View {
        NavigationView {
            Form {
                // TODO: switch to use helper function
                Section(header: Text("Hydration Goal")) {
                    Stepper("Daily Goal: \(String(format: "%.2f", hd.unit.roundForDisplay(amountInMilliliters: hd.dailyGoal, ounceRound: 8, literRound: 0.25))) \(hd.unit.rawValue)",
                            value: Binding(
                                get: {
                                    hd.unit.roundForDisplay(amountInMilliliters: hd.dailyGoal, ounceRound: 8, literRound: 0.25)
                                },
                                set: { newValue in
                                    let newGoalInML = hd.unit == .ounces ? newValue * 29.5735 : newValue * 1000
                                    hd.updateDailyGoal(newGoal: newGoalInML)
                                }
                            ),
                            in: hd.unit == .ounces ? 32...160 : 1...5,
                            step: hd.unit == .ounces ? 8 : 0.25
                    )
                    Text("Set your daily water intake goal based on your needs.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Section(header: Text("Measurement Units")) {
                    Picker("Unit", selection: $hd.unit) {
                        Text("Ounces (oz)").tag(HydrationData.Unit.ounces)
                        Text("Liters (L)").tag(HydrationData.Unit.liters)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    let glassSize = hd.unit.roundForDisplay(amountInMilliliters: hd.glassSize, ounceRound: 2, literRound: 0.25)
                    Stepper("Glass Size: \(String(format: "%.2f", glassSize)) \(hd.unit.rawValue)",
                            value: Binding(
                                get: {
                                    hd.unit.roundForDisplay(amountInMilliliters: hd.glassSize, ounceRound: 2, literRound: 0.25)
                                },
                                set: { newValue in
                                    let newSizeInML = hd.unit == .ounces ? newValue * 29.5735 : newValue * 1000
                                    hd.updateGlassSize(newSize: newSizeInML)
                                }
                            ),
                            in: hd.unit == .ounces ? 4...32 : 0.25...2,
                            step: hd.unit == .ounces ? 2 : 0.25
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


