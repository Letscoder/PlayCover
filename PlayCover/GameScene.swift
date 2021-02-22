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
        controller.test()
//        DispatchQueue.global(qos: .background).async {
//            while(true){
//                usleep(10000)
//                DispatchQueue.main.async{
//                    self.controller.updateJoystick()
//                    self.controller.updateCamera()
//                    self.controller.updateButtons()
//                }
//            }
//        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //self.controller.updateMagnify()
        //self.controller.updateCommands()
        //self.controller.updateJoystick()
        //self.controller.updateCamera()
        //self.controller.updateButtons()
    }
    
}
