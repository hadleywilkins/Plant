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
        self.backgroundColor = .clear
        // to allow sub-elements to be transparent (i think):
//        view.backgroundColor = .clear
//        view.allowsTransparency = true
        plantNode = SKSpriteNode(imageNamed: "plant")
        plantNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        plantNode.setScale(0.20) // Optional: adjust size

        addChild(plantNode)
    }
}

struct HomeView: View {
    
    var plant: SKScene {
        let scene = PlantGrow()
        scene.size = CGSize(width: 300, height: 300)
        scene.scaleMode = .fill
        return scene
    }
    @EnvironmentObject var hydrationData: HydrationData
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            SpriteView(scene: plant, options: [.allowsTransparency])
                .frame(width: 300, height: 300)
            // good for debugging/tuning layout:
//                .border(Color.black, width: 1)
            
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
