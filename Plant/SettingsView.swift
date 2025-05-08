//
//  SettingsView.swift
//  Plant
//
//  Created by redding sauter on 3/10/25.
//

import SwiftUI

//manages adjusting default units, goals, and glass size for user preferences
struct SettingsView: View {
    @EnvironmentObject var hd: HydrationData
    
    var body: some View {
        NavigationView {
            Form {
                // TODO: switch to use helper function
                Section(header: Text("Hydration Goal")) {
                    Stepper("Daily Goal: \(String(format: "%.2f", displayedValue(for: hd.dailyGoal, isGoal: true))) \(hd.unit.rawValue)",
                            value: Binding(
                                get: {
                                    displayedValue(for: hd.dailyGoal, isGoal: true)
                                    },
                                set: { newValue in
                                    let newGoalInML = milliliters(from: newValue)
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
                    
                    Stepper("Glass Size: \(String(format: "%.2f", displayedValue(for: hd.glassSize, isGoal: false))) \(hd.unit.rawValue)",
                            value: Binding(
                                get: {
                                    displayedValue(for: hd.glassSize, isGoal: false)
                                },
                                set: { newValue in
                                    let newSizeInML = milliliters(from: newValue)
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
    
    func displayedValue(for ml: Double, isGoal: Bool) -> Double {
        let ounceRound = isGoal ? 8.0 : 2.0
        let literRound = 0.25
        return hd.unit.roundForDisplay(amountInMilliliters: ml, ounceRound: ounceRound, literRound: literRound)
    }

    func milliliters(from value: Double) -> Double {
        return hd.unit.milliliters(from: value)
    }
}


