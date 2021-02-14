//
//  PlayCoverApp.swift
//  PlayCover
//
//  Created by Alex on 08.02.2021.
//

import SwiftUI
import SpriteKit

@main
struct PlayCoverApp: App {
    
    var scene: SKScene {
           let scene = GameScene()
           scene.size = CGSize(width: 300, height: 400)
           scene.scaleMode = .fill
           return scene
       }
    
    var body: some Scene {
        WindowGroup {
            SpriteView(scene: scene)
                .frame(width: 300, height: 400)
                .ignoresSafeArea()
        }
    }
    
}
