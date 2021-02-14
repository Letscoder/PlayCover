//
//  GameScene.swift
//  PlayCover
//
//  Created by Alex on 11.02.2021.
//

import Foundation
import SpriteKit
import HotKey

class GameScene: SKScene {
    
    let controller = Controller()
    var isGameMode = true
    
    override func sceneDidLoad() {
        controller.initController()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(isGameMode){
            controller.cameraStep()
            if(controller.buttons[Key.space] == true){
                isGameMode = false
            }
            if(controller.buttons[Key.w] == true){
                controller.moveJoystick(direction: FORWARD)
            }
            if(controller.buttons[Key.s] == true){
                controller.moveJoystick(direction: BOTTOM)
            }
            if(controller.buttons[Key.a] == true){
                controller.moveJoystick(direction: LEFT)
            }
            if(controller.buttons[Key.d] == true){
                controller.moveJoystick(direction: RIGHT)
            }
        }
    }
    
}
