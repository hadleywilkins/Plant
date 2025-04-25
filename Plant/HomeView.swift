//
//  HomeView.swift
//  Plant
//
//  Created by redding sauter on 3/10/25.
//

import SwiftUI
import SpriteKit

class PlantGrow: SKScene {
    private var leafNodes: [SKSpriteNode] = []
    private var potNode: SKSpriteNode!
    
    override init() {
        super.init(size: .zero)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // automatically called when the scene is fully presented by its SKView
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        // Static pot
        potNode = SKSpriteNode(imageNamed: "pot")
        potNode.size = CGSize(width: 180, height: 180)
        potNode.position = CGPoint(x: size.width / 2, y: size.width / 2)
        addChild(potNode)
        
        let anchorJSON = NSDataAsset(name: "leaf_anchors")!
        let anchors = try! JSONDecoder().decode([CGPoint].self, from: anchorJSON.data)
        
        for (leafNum, anchor) in anchors.enumerated() {
            let leafNode = SKSpriteNode(imageNamed: "leaf_\(leafNum)")
            leafNode.size = CGSize(width: 150, height: 150)
            leafNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 + 10 )
            leafNode.anchorPoint = anchor
            addChild(leafNode)
            leafNodes.append(leafNode)
        }
    }
    
    func setPlantHealth(_ health: CGFloat) {
        for (index, leafNode) in leafNodes.enumerated() {
            let newScale = max(
                0.1,
                pow(
                    health,
                    0.2 + 1.7 * Double(index) / Double(leafNodes.count)
                )
            )
            let scale = SKAction.scale(to: newScale, duration: 0.5)
            scale.timingMode = .easeInEaseOut
            leafNode.run(scale)
        }
        
        
        }
    
    func startSwayingLeaves() {
        for leafNode in leafNodes {
            
//            trying rotation here:
//            let rotateLeft = SKAction.rotate(toAngle: 0.1, duration: 0.2)
//            let rotateRight = SKAction.rotate(toAngle: -0.1, duration: 0.2)
//            rotateLeft.timingMode = .easeInEaseOut
//            rotateRight.timingMode = .easeInEaseOut
//            let group = SKAction.sequence([rotateLeft, rotateRight])
//            let sway = SKAction.repeatForever(group)
//            leafNode.run(sway)
            
            //Trying movement here
            let moveRight = SKAction.moveBy(x:1, y: 0, duration: 2)
            moveRight.timingMode = .easeInEaseOut
            let moveLeft = SKAction.moveBy(x: -1, y: 0, duration: 2)
            moveLeft.timingMode = .easeInEaseOut
            let moveBackAndForth = SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft]))
                    leafNode.run(moveBackAndForth)
            
        }
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
                    plantScene.startSwayingLeaves()
                    
                }
            
            

            // good for debugging/tuning layout:
//                .border(Color.black, width: 1)
            
            Text("Have you had water today?")
                .font(.subheadline)
            
            ProgressView(value: Double(hydrationData.waterIntake), total: Double(hydrationData.dailyGoal))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(width: 200)
            
            //Text("\(hydrationData.unit.format(amountInMilliliters: hydrationData.waterIntake)) / \(hydrationData.unit.format(amountInMilliliters: hydrationData.dailyGoal))")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("\(hydrationData.unit.format(amountInMilliliters: hydrationData.waterIntake)) / \(hydrationData.unit.roundForDisplay(amountInMilliliters: hydrationData.dailyGoal, ounceRound: 8, literRound: 0.25)))")
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
