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
    
    override init() {
        super.init(size: .zero)
        self.backgroundColor = .clear
        // to allow sub-elements to be transparent (i think):
//        view.backgroundColor = .clear
//        view.allowsTransparency = true
        plantNode = SKSpriteNode(imageNamed: "plant")
        plantNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(plantNode)
        setPlantHealth(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlantHealth(_ health: CGFloat) {
        plantNode.yScale = health
    }
}

func makePlantScene() -> PlantGrow {
    let scene = PlantGrow()
    scene.size = CGSize(width: 300, height: 300)
    scene.scaleMode = .fill
    scene.setScale(0.20)
    return scene
}

let plantScene = makePlantScene()

struct HomeView: View {
    @EnvironmentObject var hydrationData: HydrationData
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            SpriteView(scene: plantScene, options: [.allowsTransparency])
                .frame(width: 300, height: 300)
                .onChange(of: hydrationData.waterIntake) {
                    plantScene.setPlantHealth(hydrationData.waterIntake / hydrationData.dailyGoal)
                }
            
            

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
