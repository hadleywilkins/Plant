//
//  PlantView.swift
//  Plant
//
//  Created by Rishika Kundu on 9/29/25.
//

import SpriteKit


/// SpriteKit scene that visually represents a plant with growing leaves based on hydration data.
class PlantView: SKScene {
    private var leafNodes: [SKSpriteNode] = []
    private var potNode: SKSpriteNode!
    private var stemNode: SKSpriteNode!
    
    //public static let leaf duration
    public var plantHealth: CGFloat = 0 {
        didSet {
            updatePlantGraphics()
        }
    }
    
    override init() {
        super.init(size: .zero)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        // Static pot
        potNode = SKSpriteNode(imageNamed: "pot")
        potNode.size = CGSize(width: 180, height: 180)
        potNode.position = CGPoint(x: size.width / 2, y: size.width / 2)
        addChild(potNode)
        
        // Static Stem
        stemNode = SKSpriteNode(imageNamed: "stem")
        stemNode.size = CGSize(width: 200, height: 200)
        stemNode.position = CGPoint(x:100, y: 75)
        addChild(stemNode)
        
        // Leaves being anchored
        let anchorJSON = NSDataAsset(name: "leaf_anchors")!
        let anchors = try! JSONDecoder().decode([CGPoint].self, from: anchorJSON.data)
        
        for (leafNum, anchor) in anchors.enumerated() {
            let leafNode = SKSpriteNode(imageNamed: "leaf_\(leafNum)")
            leafNode.size = CGSize(width: 150, height: 150)
            leafNode.position = CGPoint(
                x: self.size.width * 0.5 + leafNode.size.width * (anchor.x - 0.5),
                y: self.size.height * 0.5 + leafNode.size.height * (anchor.y - 0.5)
            )
            leafNode.anchorPoint = anchor
            leafNode.setScale(0)
            addChild(leafNode)
            leafNodes.append(leafNode)
        }
        
        updatePlantGraphics()
    }
    
    
    //Custom function to grow leaves of the plant. Leaves grow in sequence so some appear faster than others.
    func updatePlantGraphics() {
        let leafGrowthTime = 0.5
        let maxLeafStartTime = 1 - leafGrowthTime
        for (leafNum, leafNode) in leafNodes.enumerated() {
            let leafStartTime = maxLeafStartTime * CGFloat(leafNum) / CGFloat(leafNodes.count - 1)
            let growthTimeElapsed = plantHealth - leafStartTime
            let growthLine = growthTimeElapsed / leafGrowthTime
            let newScale = min(1, max(0, growthLine)) //pinning growthline between 0 and 1
            
            let scale = SKAction.scale(to: newScale, duration: 0.5)
            scale.timingMode = .easeInEaseOut
            leafNode.run(scale)
        }
    }
    
    func startSwayingLeaves() {
        
        for leafNode in leafNodes {
                let angle = CGFloat.random(in: 0.005...0.015)
                let duration = Double.random(in: 0.8...1.6)
                let rotateLeft = SKAction.rotate(toAngle: angle, duration: duration)
                let rotateRight = SKAction.rotate(toAngle: -angle, duration: duration)
                rotateLeft.timingMode = .easeInEaseOut
                rotateRight.timingMode = .easeInEaseOut
                let swaySequence = SKAction.sequence([rotateLeft, rotateRight])
                let swayForever = SKAction.repeatForever(swaySequence)
                leafNode.run(swayForever)

        }
    }
}
