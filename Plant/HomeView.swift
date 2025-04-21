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
//        self.backgroundColor = .clear
//        // to allow sub-elements to be transparent (i think):
////        view.backgroundColor = .clear
////        view.allowsTransparency = true
//        plantNode = SKSpriteNode(imageNamed: "plant")
//        plantNode.size = CGSize(width: 200, height: 200)
//        plantNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        addChild(plantNode)
//        setPlantHealth(0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // automatically called when the scene is fully presented by its SKView
    override func didMove(to view: SKView) {
            self.backgroundColor = .clear
            plantNode = SKSpriteNode(imageNamed: "plant")
            plantNode.size = CGSize(width: 200, height: 200)
            plantNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            addChild(plantNode)
            setPlantHealth(0.1)
        }
    func setPlantHealth(_ health: CGFloat) {
        let newScale = max(0.1, health)
                let scaleX = SKAction.scaleX(to: newScale, duration: 0.5)
                let scaleY = SKAction.scaleY(to: newScale, duration: 0.5)
                let group = SKAction.group([scaleX, scaleY])
                group.timingMode = .easeInEaseOut
                plantNode.run(group)
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
