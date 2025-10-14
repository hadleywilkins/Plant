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
        .configurationDisplayName("Plant Widget")
        .description("This is a Widget of the plant app")
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
    
    private var plantImageName: String {
        
        let goal = max(entry.goal, 1)
        let ratio = entry.intake / goal
        let clamped = min(max(ratio, 0), 1)
        let step = (clamped * 4).rounded() / 4
        return "plant-\(step)"
    }

    var body: some View {
        
        VStack {
            Image(plantImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
            
            
            Text("Water Intake: ")
                .font(.system(.title, design: .serif))
                .fontWidth(.compressed)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.36, green: 0.25, blue: 0.20))
            
            ProgressView(value: Double(entry.intake), total: Double(entry.goal))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .padding(.bottom, 20)
        }
        .containerBackground(for: .widget) {
            Color(red: 0.80, green: 0.70, blue: 0.55)
        }
    }
}
