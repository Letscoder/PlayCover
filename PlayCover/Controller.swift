import SwiftUI
import Foundation
import UserNotifications
import SpriteKit
import Carbon.HIToolbox

let SCREEN_CENTER = CGPoint(x: 720, y: 450)

class Controller {
    
    let source = CGEventSource.init(stateID: CGEventSourceStateID.combinedSessionState)
    
    var buttons = [
        3 : false,
        49 : false,
        57 : false,
        14 : false,
        13 : false,
        1 : false,
        0 : false,
        2 : false,
        125 : false,
        126 : false,
        124 : false,
        123 : false,
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
        
            if(buttons[13] == true){
                moveDy = CGFloat(700)
            }
            if(buttons[1] == true){
                moveDy = CGFloat(800)
            }
            if(buttons[0] == true){
                moveDx = CGFloat(250)
            }
            if(buttons[2] == true){
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
        
        if(buttons[125] == true){
            cameraDy = CGFloat(2)
        }
        if(buttons[126] == true){
            cameraDy = CGFloat(-2)
        }
        if(buttons[124] == true){
            cameraDx = CGFloat(2)
        }
        if(buttons[123] == true){
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
    
    let RUN_BTN = CGPoint(x: 1225, y: 800)
    let SPACE_BTN = CGPoint(x: 1230, y: 670)
    let ACTION_BTN  = CGPoint(x: 950, y: 450)
    
    func updateButtons(){
        if(buttons[57] == true){
            performClick(point: RUN_BTN)
        }
        if(buttons[3] == true){
            performClick(point: ACTION_BTN)
        }
        if(buttons[49] == true){
            performClick(point: SPACE_BTN)
        }
    }
    
    func initController(){
        source?.localEventsSuppressionInterval = 0
        performClick(point: SCREEN_CENTER)
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown, handler: {(keyEvent:NSEvent) in
           
            self.buttons[Int(keyEvent.keyCode)] = true
        
            })
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.keyUp, handler: {(keyEvent:NSEvent) in
           
            self.buttons[Int(keyEvent.keyCode)] = false
        
            })
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.flagsChanged, handler: {(keyEvent:NSEvent) in
           
            switch keyEvent.modifierFlags.intersection(.deviceIndependentFlagsMask) {
            case [.shift]: self.buttons[57] = !self.buttons[57]!
             default:break
        }
        }
            )
    }
  }
    
