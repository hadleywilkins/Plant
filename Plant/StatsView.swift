//
//  StatsView.swift
//  Plant
//
//  Created by Hadley Wilkins on 3/26/25.
//

import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @EnvironmentObject var hd: HydrationData
    @Environment(\.modelContext) private var context
    @AppStorage("lastLoggedDate") var lastLoggedDate: String = ""
    let currentDate = Date()
    @Query private var days: [WaterDay]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [PlantApp.colors.tan, PlantApp.colors.brown]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Hydration Data")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(PlantApp.colors.darkbrown)
                
                ProgressView(value: Double(hd.waterIntake), total: Double(hd.dailyGoal))
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 250)
                
                Text("\(hd.getTotalIntakeFormatted()) / \(hd.getDailyGoalFormatted())")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
                
                Chart {
                    ForEach(days) { day in
                        let intake = hd.unit.value(amountInMilliliters: day.intake)
                        BarMark(
                            x: .value("Date", formattedDate(day.date)),
                            y: .value("Intake", intake)
                        )
                    }
                    // sets the vertical line to _today's_ goal
                    let goal = hd.unit.value(amountInMilliliters: hd.dailyGoal)
                    RuleMark(y: .value("Goal", goal))
                        .foregroundStyle(PlantApp.colors.red)
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                
                // put List inside VStack so gradient applies
                List {
                    ForEach(days) { day in
                        let intake = hd.unit.format(amountInMilliliters: day.intake, grainCoarse: false)
                        let goal = hd.unit.format(amountInMilliliters: day.goal, grainCoarse: true)
                        Text("\(formattedDate(day.date)): \(intake)/\(goal)")
                    }
                    .onDelete { indices in
                        for index in indices {
                            deleteDay(day: days[index])
                        }
                    }
                }
                .scrollContentBackground(.hidden) // removes default system background
                .background(Color.clear)          // transparent, lets gradient show
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                checkAndResetIfNewDay()
            }
        }
    }
    
    func checkAndResetIfNewDay() {
        let today = formattedDate(currentDate)
        if today != lastLoggedDate {
            if hd.waterIntake > 0 {
                addDay()
            }
            hd.resetDailyIntake()
            lastLoggedDate = today
        }
    }
    
    func addDay() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? currentDate
        let newDay = WaterDay(date: yesterday, goal: hd.dailyGoal, intake: hd.waterIntake)
        context.insert(newDay)
        hd.resetDailyIntake()
    }
    
    func deleteDay(day: WaterDay) {
        context.delete(day)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
