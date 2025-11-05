//
//  HomeView.swift
//  Plant
//
//  Created by redding sauter on 3/10/25.
//

import SwiftUI
import SpriteKit
import Oklch
import Metal



func makePlantScene() -> PlantView {
    let scene = PlantView()
    scene.size = CGSize(width: 180, height: 180)
    scene.scaleMode = .fill
    scene.setScale(1)
    return scene
}

let plantScene = makePlantScene()

struct HomeView: View {
    @EnvironmentObject var hd: HydrationData
    @State var isPresentingConf: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(
                            colors: [PlantApp.colors.tan, PlantApp.colors.brown]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing)
                .ignoresSafeArea()

            
            VStack(spacing: 20) {
                
                let screenWidth  = UIScreen.main.bounds.width
                
                SpriteView(scene: plantScene, options: [.allowsTransparency])
                    .frame(maxWidth: screenWidth)
                    .padding(.all, 0)
                    .aspectRatio(1, contentMode: .fit)
                    .ignoresSafeArea(edges: .horizontal)
                    .onChange(of: hd.waterIntake) {
                        plantScene.plantHealth = hd.waterIntake / hd.dailyGoal
                        plantScene.startSwayingLeaves()
                    }

                Text("Have you had water today?")
                    .font(.system(.title, design: .serif))
                    .fontWidth(.compressed)
                    .fontWeight(.bold)
                    .foregroundColor(PlantApp.colors.darkbrown)
                
                ProgressView(value: Double(hd.waterIntake), total: Double(hd.dailyGoal))
                    .frame(width: 200)
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                
                             
                let intake = hd.getTotalIntakeFormatted()
                let goal = hd.getDailyGoalFormatted()
                Text("\(intake) / \(goal)")
                    .font(.system(.headline, design:.default))
                    .foregroundColor(PlantApp.colors.darkbrown)
                
                HStack {
                    Button(action: {
                        hd.logGlassOfWater()
                    }) {
                        Text("Log a Glass of Water")
                            .padding()
                            .frame(width: 150, height: 75)
                            .background(PlantApp.colors.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .fontDesign(.default)
                    }
                    .padding(.top, 10)
                    
                    Button(action: {
                        isPresentingConf = true
                    }) {
                        Text("Reset")
                            .padding()
                            .frame(width: 150, height: 75)
                            .background(PlantApp.colors.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .fontDesign(.default)
                    }
                    .padding(.top, 10)
                    .confirmationDialog("Are you sure?", isPresented: $isPresentingConf) {
                           Button("Reset today's intake?", role: .destructive) {
                               hd.resetDailyIntake()
                           }
                       } message: {
                           Text("You cannot undo this action.")
                       }
                }

            }
            .padding()
            
        }
        .onAppear {
            plantScene.plantHealth = hd.waterIntake / hd.dailyGoal
            plantScene.startSwayingLeaves()
        }
    }
}
