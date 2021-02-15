//
//  GameScene.swift
//  PlayCover
//
//  Created by Alex on 11.02.2021.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    let controller = Controller()
    
    override func sceneDidLoad() {
        controller.initController()
    }
    
    override func update(_ currentTime: TimeInterval) {
        controller.updateCamera()
        controller.updateJoystick()
        controller.updateButtons()
    }
    
}
