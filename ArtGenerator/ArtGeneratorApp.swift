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
            VStack {
                SpriteView(scene: plantScene, options: [.allowsTransparency])
                    .frame(width: 400, height: 400)
                    .task(generateImages)
            }
        }
    }
    
    @Sendable
    func generateImages() async {
        // for n in 0...10 { ... }
        // for n in 0..<10 { ... }
        // for n in stride(from: 0, to: 100, by: 5) { ... }

        // https://stackoverflow.com/a/61720423/239816
        //plantScene.plantHealth = 100
        

        
        for health in stride(from:0.0, through: 1.1, by: 0.25) {
   
            print("---->", health)
            plantScene.plantHealth = health

            

            try? await Task.sleep(for: .seconds(0.6))
            
            //try? await Task.sleep(for: .seconds(3))
                
            let result = (plantScene.view?.texture(from: plantScene))!
            let image = NSImage(cgImage: result.cgImage(), size: result.size())

            guard let tiffData = image.tiffRepresentation,
            let bitmap = NSBitmapImageRep(data: tiffData),
            let pngData = bitmap.representation(using: .png, properties: [:]) else {
                print("Failed to create PNG data")
                return
            }
            
            let tempDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            let fileURL = tempDir.appendingPathComponent("plant-\(plantScene.plantHealth).png")

            do {
                try pngData.write(to: fileURL)
                print("Saved image to \(fileURL.path)")
            } catch {
                print("Error saving image:", error)
            }
            
       
            
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
