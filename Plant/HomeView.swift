//
//  HomeView.swift
//  Plant
//
//  Created by redding sauter on 3/10/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var hydrationData: HydrationData
    
    var body: some View {
        VStack(spacing: 20){
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            Image(systemName: "tree")
                .imageScale(.large)
                .foregroundStyle(.green)
            
            Text("Have you had water today?")
                .font(.subheadline)
            
            ProgressView(value: Double(hydrationData.waterIntake), total: Double(hydrationData.dailyGoal))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(width: 200)
            
            Text("\(hydrationData.unit.format(amountInMilliliters: hydrationData.waterIntake)) / \(hydrationData.unit.format(amountInMilliliters: hydrationData.dailyGoal))")
                .font(.subheadline)
                .foregroundColor(.gray)

            Button(action: {
                hydrationData.logGlassOfWater()
            }) {
                Text("Log a Glass of Water")
                    .padding()
                    .frame(width: 150)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
            
            Button(action: {
                hydrationData.resetDailyIntake()
            }) {
                Text("Reset")
                    .padding()
                    .frame(width: 150)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)

            Spacer()
        }
        .padding()
    }
}
