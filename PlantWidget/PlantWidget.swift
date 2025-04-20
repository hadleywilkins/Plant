//
//  PlantWidget.swift
//  PlantWidget
//
//  Created by Rishika Kundu on 3/25/25.
//

import SwiftUI
import WidgetKit

struct PlantWidget: Widget {
    let kind: String = "PlantWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            widView(entry: entry)
        }
        .configurationDisplayName("Your Widget")
        .description("This is an example widget.")
    }
}

struct PlantEntry: TimelineEntry {
    let date: Date
    let intake: Double
    let goal: Double
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PlantEntry {
        PlantEntry(date: Date(), intake: 404, goal: 404)
    }

    func getSnapshot(in context: Context, completion: @escaping (PlantEntry) -> ()) {
        let entry = PlantEntry(date: Date(), intake: 50, goal: 100)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PlantEntry>) -> ()) {
        let currentDate = Date()
        let entry = PlantEntry(date: currentDate, intake: getIntake(), goal: getGoal())

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    func getIntake() -> Double {
        // make sure you use your app group identifier as the suitname
        guard let defaults = UserDefaults(suiteName: "group.com.resariha.plantwidget") else {
            return 404
        }
        return defaults.double(forKey: "waterIntake")
    }
    func getGoal() -> Double {
        guard let defaults = UserDefaults(suiteName: "group.com.resariha.plantwidget") else {
            return 404
        }
        return defaults.double(forKey: "dailyGoal")
    }
}

struct widView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Water Intake: ")
                .font(.title)
            
            ProgressView(value: Double(entry.intake), total: Double(entry.goal))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
        }
    }
}
