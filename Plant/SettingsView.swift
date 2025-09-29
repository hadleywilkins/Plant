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
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @AppStorage("notificationFrequency") private var notificationFrequency: String = "once"
    
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
                //Notification Picker
                Section() {
                        Toggle("Enable Notifictions", isOn: $notificationsEnabled)
                                .toggleStyle(.switch)
                                .tint(PlantApp.colors.darkbrown)
                                .onChange(of: notificationsEnabled) { _, newValue in
                                    if newValue {
                                        NotificationManager.requestPermission { granted in
                                            DispatchQueue.main.async {
                                                if granted {
                                                    NotificationManager.scheduleNotifications(frequency: notificationFrequency)
                                                } else {
                                                    notificationsEnabled = false // reset toggle if denied
                                                    }
                                                }
                                            }
                                        } else {
                                            NotificationManager.cancelNotifications()
                                                        // keep the stored frequency, so when user toggles back on,
                                                        // we know what to reschedule
                                        }
                                    }
                                .cardStyle()
                                .padding()
                        } header: {
                            Text("Notifications")
                                .sectionHeaderStyle()
                        }
            
                if notificationsEnabled {
                        Section() {
                            VStack(alignment: .leading, spacing: 12) {
                                Picker("Frequency", selection: $notificationFrequency) {
                                    Text("Once a Day").tag("once")
                                    Text("Twice a Day").tag("twice")
                                    Text("Three times a Day").tag("three")
                                }
                                .pickerStyle(.menu)
                                .onChange(of: notificationFrequency) { _, newValue in
                                    NotificationManager.scheduleNotifications(frequency: notificationFrequency)
                                }
                            }
                            .cardStyle()
                        }
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
    static func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        if let error = error {
                            print("Notification permission error: \(error.localizedDescription)")
                        }
                        completion(granted)
                    }
        }
        
    static func scheduleNotifications(frequency: String) {
            cancelNotifications() //cancel old notifs
        
            let content = UNMutableNotificationContent() //set up content for new mesages
            content.title = "Water me!"
            content.subtitle = "Time to hydrate 💧"
            content.sound = .default

            // Decide times based on frequency
            let hours: [Int]
            switch frequency {
            case "once": hours = [13]
            case "twice": hours = [8, 19]
            case "three": hours = [8, 13, 20]
            default: hours = []
            }

            let notificationCenter = UNUserNotificationCenter.current()

            for (index, hour) in hours.enumerated() {
                var dateComponents = DateComponents()
                dateComponents.hour = hour

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(
                    identifier: "hydration_\(index)", // identifiers
                    content: content,
                    trigger: trigger
                )

                notificationCenter.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)") //print debug
                    }
                }
            }
        }

        
        static func cancelNotifications() {
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests { requests in
                let idsToRemove = requests.map(\.identifier).filter { $0.hasPrefix("hydration_") }
                if !idsToRemove.isEmpty {
                    center.removePendingNotificationRequests(withIdentifiers: idsToRemove)
                    print("Cancelled notifications: \(idsToRemove)") //debug print statements
                }
            }
        }
    }
