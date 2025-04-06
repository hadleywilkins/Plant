//
//  StatsView.swift
//  Plant
//
//  Created by Hadley Wilkins on 3/26/25.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @EnvironmentObject var hydrationData: HydrationData
    @Environment(\.modelContext) private var context
    
    @Query private var days: [WaterDay]
    var body: some View {
        VStack(spacing: 20) {
            Text("Hydration Stats")
                .font(.largeTitle)
                .fontWeight(.bold)

        ProgressView(value: Double(hydrationData.waterIntake), total: Double(hydrationData.dailyGoal))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(width: 250)

            Text("\(String(format: "%.1f", hydrationData.getTotalIntake())) / \(String(format: "%.1f", hydrationData.getDailyGoal())) \(hydrationData.unit)")
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
            
            List {
                ForEach(days) { day in
                    Text("\(day.date): \(day.intake)/\(day.goal)")
                }
                .onDelete { indices in
                    for index in indices {
                        deleteDay(day: days[index])
                    }
            }
            }

        }
    }
    
    func addDay() {
        let newDay = WaterDay(date: "chewsday", goal:hydrationData.dailyGoal, intake:hydrationData.waterIntake)
        context.insert(newDay)
        hydrationData.resetDailyIntake()
    }
    
    func deleteDay(day: WaterDay) {
        context.delete(day)
    }
}
