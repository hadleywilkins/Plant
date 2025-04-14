//
//  HomeView.swift
//  Plant
//
//  Created by redding sauter on 3/10/25.
//

import SwiftUI
import SpriteKit

class PlantGrow: SKScene {
    private var plantNode: SKSpriteNode!

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        plantNode = SKSpriteNode(imageNamed: "plant")
        plantNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        plantNode.setScale(0.20) // Optional: adjust size

        addChild(plantNode)
    }
}

struct HomeView: View {
    
    var scene:SKScene{
        let scene = PlantGrow()
        scene.size = CGSize(width:300,height:400)
        scene.scaleMode = .fill
        return scene
    }
    @EnvironmentObject var hydrationData: HydrationData
    
    var body: some View {
        
        SpriteView(scene: scene)
            .frame(width:300,height:400)
        
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
