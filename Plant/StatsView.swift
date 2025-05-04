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
    @EnvironmentObject var hydrationData: HydrationData
    @Environment(\.modelContext) private var context
    @AppStorage("lastLoggedDate") var lastLoggedDate: String = ""
    let currentDate = Date()
    
    @Query private var days: [WaterDay]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hydration Stats")
                .font(.largeTitle)
                .fontWeight(.bold)

        ProgressView(value: Double(hydrationData.waterIntake), total: Double(hydrationData.dailyGoal))
                .progressViewStyle(LinearProgressViewStyle())
                .frame(width: 250)

            Text("\(hydrationData.getTotalIntakeFormatted()) / \(hydrationData.getDailyGoalFormatted())")
                            .font(.subheadline)
                            .foregroundColor(.gray)
            
            Button(action: {
                addDay()
            }) {
                Text("New Day")
                    .padding()
                    .frame(width: 150)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Chart {
                ForEach(days) { day in
                    BarMark(
                        x: .value("Date", formattedDate(day.date)),
                        y: .value("Intake", hydrationData.unit.value(amountInMilliliters: day.intake))
                    )
                }
            }
            
            //Storing as raw type in water day which is good for graph, but need formated type for this part of display
            List {
                ForEach(days) { day in
                    Text("\(formattedDate(day.date)): \(hydrationData.unit.format(amountInMilliliters: day.intake))/\(hydrationData.unit.format(amountInMilliliters: day.goal))")
                }
                .onDelete { indices in
                    for index in indices {
                        deleteDay(day: days[index])
                    }
            }
            }
            //only checks when stat view is opened, refactor to on home view opened
            .onAppear {
                 checkAndResetIfNewDay()
            }

        }
    }
    
    func checkAndResetIfNewDay() {
        let today = formattedDate(currentDate)
        if today != lastLoggedDate {
            if hydrationData.waterIntake > 0 { // Save previous day if intake exists
                addDay()
            }
            hydrationData.resetDailyIntake()
            lastLoggedDate = today
        }
    }
    
    //adds current date rather than previous, refactor to store yesterday
    func addDay() {
        let newDay = WaterDay(date: currentDate, goal:hydrationData.dailyGoal, intake:hydrationData.waterIntake)
        context.insert(newDay)
        hydrationData.resetDailyIntake()
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
