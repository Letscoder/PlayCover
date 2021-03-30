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
    
    private func readPrivileges(prompt: Bool){
        let prefPage = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        if let url = URL(string: prefPage) {
            NSWorkspace.shared.open(url)
        }
    }
    
    override func sceneDidLoad() {
        controller.initController()
//        DispatchQueue.global(qos: .background).async {
//            while(true){
//                usleep(10000)
//                DispatchQueue.main.async{
//
//                }
//            }
//        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.controller.updateCommands()
        self.controller.updateJoystick()
        self.controller.updateCamera()
        self.controller.updateButtons()
    }
    
}
