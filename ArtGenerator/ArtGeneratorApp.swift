//
//  ArtGeneratorApp.swift
//  ArtGenerator
//
//  Created by Rishika Kundu on 9/29/25.
//

import SwiftUI
import SpriteKit

// Plan:
// - Show plant SpriteKit View in this app too (shared between both!!)
// - Add button or something to save to file
// - Automate generating many files at different %ages


@main
struct ArtGeneratorApp: App {
    var body: some Scene {
        WindowGroup {
            SpriteView(scene: plantScene, options: [.allowsTransparency])
                .frame(width: 400, height: 400)
        }
    }
}

func makePlantScene() -> PlantView {
    let scene = PlantView()
    scene.size = CGSize(width: 180, height: 180)
    scene.scaleMode = .fill
    scene.setScale(1)
    return scene
}

let plantScene = makePlantScene()
