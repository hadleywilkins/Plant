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
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [PlantApp.colors.tan, PlantApp.colors.brown]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                List {
                    // Hydration Goal
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Stepper("Daily Goal: \(hd.getDailyGoalFormatted())",
                                    value: Binding(
                                        get: { hd.unit.roundValue(amountInMilliliters: hd.dailyGoal, grainCoarse: true) },
                                        set: { newValue in
                                            let ml = hd.unit == .ounces ? newValue * 29.5735 : newValue * 1000
                                            hd.updateDailyGoal(newGoal: ml)
                                        }
                                    ),
                                    in: hd.unit == .ounces ? 32...160 : 1...5,
                                    step: hd.unit == .ounces ? 8 : 0.5
                            )
                            Text("Set your daily water intake goal based on your needs.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.85))
                        }
                        .padding()
                        .background(PlantApp.colors.tan)
                        .cornerRadius(12)
                        .padding(.horizontal) // 👈 space from screen edges
                    } header: {
                        Text("Hydration Goal")
                            .foregroundColor(PlantApp.colors.darkbrown)
                            .padding(.leading) // align header with card
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                    // Measurement Units
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Picker("Unit", selection: $hd.unit) {
                                Text("Ounces (oz)").tag(HydrationData.Unit.ounces)
                                Text("Liters (L)").tag(HydrationData.Unit.liters)
                            }
                            .pickerStyle(.segmented)

                            Stepper("Glass Size: \(hd.getGlassSizeFormatted())",
                                    value: Binding(
                                        get: { hd.unit.roundValue(amountInMilliliters: hd.glassSize, grainCoarse: false) },
                                        set: { newValue in
                                            let ml = hd.unit == .ounces ? newValue * 29.5735 : newValue * 1000
                                            hd.updateGlassSize(newSize: ml)
                                        }
                                    ),
                                    in: hd.unit == .ounces ? 4...32 : 0.25...2,
                                    step: hd.unit == .ounces ? 2 : 0.25
                            )
                            Text("Adjust the size of a single glass of water.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.85))
                        }
                        .padding()
                        .background(PlantApp.colors.tan)
                        .cornerRadius(12)
                        .padding(.horizontal) // 👈 space from screen edges
                    } header: {
                        Text("Measurement Units")
                            .foregroundColor(PlantApp.colors.darkbrown)
                            .padding(.leading)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .listStyle(.plain)
                .listSectionSeparator(.hidden)
            }
            .navigationTitle("Settings")
        }
    }
}
