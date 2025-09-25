//
//  SettingsView.swift
//  Plant
//
//  Created by redding sauter on 3/10/25.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject var hd: HydrationData
    @State private var testNotificationEnabled = false
    @State private var notificationTime = Date()
    
    var body: some View {
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
                    .cardStyle()
                } header: {
                    Text("Hydration Goal")
                        .sectionHeaderStyle()
                }
                    
                    // Measurement Units
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Picker("Unit", selection: $hd.unit) {
                                Text("Ounces (oz)").tag(HydrationData.Unit.ounces)
                                Text("Liters (L)").tag(HydrationData.Unit.liters)
                            }
                            .pickerStyle(.segmented)
                            .tint(PlantApp.colors.darkbrown)
                            
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
                        .cardStyle()
                    } header: {
                        Text("Measurement Units")
                            .sectionHeaderStyle()
                    }
                    
                Section() {
                        Toggle("Enable Notifictions", isOn: $testNotificationEnabled)
                                .toggleStyle(.switch)
                                .tint(PlantApp.colors.darkbrown)
                                .onChange(of: testNotificationEnabled) { newValue in
                                        if newValue {
                                            NotificationManager.scheduleTestNotification()
                                        } else {
                                            NotificationManager.cancelTestNotification()
                                        }
                                }
                                .cardStyle()
                        } header: {
                            Text("Notifications")
                                .sectionHeaderStyle()
                        }
                        
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .listStyle(.plain)
                .listSectionSeparator(.hidden)
            }
            .navigationTitle("Settings")
        }
    }

//Helpers
extension View {
    func cardStyle() -> some View {
        self.padding()
            .background(PlantApp.colors.tan)
            .cornerRadius(10)
            .padding(.horizontal)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    
    func sectionHeaderStyle() -> some View {
        self.foregroundColor(PlantApp.colors.darkbrown)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

enum NotificationManager {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Permission approved!")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
        
        static func scheduleTestNotification() {
            let content = UNMutableNotificationContent()
            content.title = "Hydration Reminder"
            content.subtitle = "Time for a glass of water 💧"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "basic_notification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
            
        }
        
        static func cancelTestNotification() {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["test_notification"])
        }
    }
