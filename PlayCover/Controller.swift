import SwiftUI
import Foundation
import HotKey
import UserNotifications
import SpriteKit
import Carbon.HIToolbox

let SCREEN_CENTER = CGPoint(x: 720, y: 450)

class Controller {
    
    let source = CGEventSource.init(stateID: CGEventSourceStateID.combinedSessionState)
    
    var buttons = [
        Key.space : false,
        Key.e : false,
        Key.w : false,
        Key.s : false,
        Key.a : false,
        Key.d : false,
        Key.downArrow : false,
        Key.upArrow : false,
        Key.rightArrow : false,
        Key.leftArrow : false,
    ]

    func performClick(point: CGPoint){
        let eventDown = CGEvent(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: point , mouseButton: .left)
        let eventUp = CGEvent(mouseEventSource: source, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left)
        eventDown?.post(tap: .cghidEventTap)
        eventUp?.post(tap: .cghidEventTap)
    }

    private func moveJoystick(direction: CGPoint){
        let position = direction
        let eventDown = CGEvent(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: position , mouseButton: .left)
        eventDown?.post(tap: .cghidEventTap)
    }
    
    var isMoving = false
    
    func updateJoystick(){
        var moveDx = CGFloat(310)
        var moveDy = CGFloat(740)
        
            if(buttons[Key.w] == true){
                moveDy = CGFloat(700)
            }
            if(buttons[Key.s] == true){
                moveDy = CGFloat(800)
            }
            if(buttons[Key.a] == true){
                moveDx = CGFloat(250)
            }
            if(buttons[Key.d] == true){
                moveDx = CGFloat(350)
            }
        
        
        if(!moveDx.isEqual(to: CGFloat(310)) || !moveDy.isEqual(to: CGFloat(740))){
            isMoving = true
            moveJoystick(direction: CGPoint(x: moveDx, y: moveDy))
        } else{
            if(isMoving){
                stopJoystick(direction: SCREEN_CENTER)
                isMoving = false
            }
        }
    }
    
    func stopJoystick(direction: CGPoint){
        let position = direction
        let eventUp = CGEvent(mouseEventSource: source, mouseType: .leftMouseUp, mouseCursorPosition: position , mouseButton: .left)
        eventUp?.post(tap: .cghidEventTap)
    }
    
    var isCameraMoving = false
    
    private func cameraRotate(dx : CGFloat, dy: CGFloat){
             let mousePos = NSEvent.mouseLocation
             let cursorPos = CGPoint(x: mousePos.x, y: NSScreen.main!.frame.maxY - mousePos.y)
        let nextPos = CGPoint(x: cursorPos.x + dx, y: cursorPos.y + dy)
            let startTap = CGEvent(mouseEventSource: self.source, mouseType: .leftMouseDown, mouseCursorPosition: cursorPos, mouseButton: .left)
            startTap?.post(tap: .cghidEventTap)
            let endTap = CGEvent(mouseEventSource: self.source, mouseType: .leftMouseDown, mouseCursorPosition: nextPos, mouseButton: .left)
            endTap?.post(tap: .cghidEventTap)
            }
    
    func updateCamera(){
        var cameraDx = CGFloat(0)
        var cameraDy = CGFloat(0)
        
        if(buttons[Key.downArrow] == true){
            cameraDy = CGFloat(2)
        }
        if(buttons[Key.upArrow] == true){
            cameraDy = CGFloat(-2)
        }
        if(buttons[Key.rightArrow] == true){
            cameraDx = CGFloat(2)
        }
        if(buttons[Key.leftArrow] == true){
            cameraDx = CGFloat(-2)
        }
        
        if(!cameraDx.isZero || !cameraDy.isZero){
            isCameraMoving = true
            cameraRotate(dx: cameraDx, dy: cameraDy)
        } else{
            if(isCameraMoving){
                stopJoystick(direction: SCREEN_CENTER)
                isCameraMoving = false
            }
        }
    }
    
    func initController(){
        source?.localEventsSuppressionInterval = 0
        performClick(point: SCREEN_CENTER)

        var buttonList = [HotKey]()
        for (key, value) in buttons{
            var nKey = HotKey(key: key, modifiers: [])
            nKey.keyDownHandler = {
                self.buttons[key] = true
            nKey.keyUpHandler = {
                self.buttons[key] = false
            }
            buttonList.append(nKey)
        }
    }
  }
    
}
