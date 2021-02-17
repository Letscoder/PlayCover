import SwiftUI
import Foundation
import UserNotifications
import SpriteKit
import Carbon.HIToolbox

let SCREEN_CENTER = CGPoint(x: 720, y: 450)

let ZERO = CGFloat(0)

class Controller {
    
    var source : CGEventSource?
    
    var buttons = [
        Keycode.m : false,
        Keycode.rightMouse : false,
        Keycode.space : false,
        Keycode.upArrow : false,
        Keycode.downArrow : false,
        Keycode.rightArrow: false ,
        Keycode.leftArrow: false,
        Keycode.w: false,
        Keycode.a: false,
        Keycode.s: false,
        Keycode.d: false,
        Keycode.e: false,
        Keycode.f: false,
        Keycode.r: false
    ]

    func performClick(point: CGPoint){
        DispatchQueue.main.async {
            let eventDown = CGEvent(mouseEventSource: self.source, mouseType: .leftMouseDown, mouseCursorPosition: point , mouseButton: .left)
            let eventUp = CGEvent(mouseEventSource: self.source, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left)
            eventDown?.post(tap: .cghidEventTap)
            eventUp?.post(tap: .cghidEventTap)
        }
    }

    private func moveJoystick(direction: CGPoint){
        DispatchQueue.main.async {
            let position = direction
            let eventDown = CGEvent(mouseEventSource: self.source, mouseType: .leftMouseDown, mouseCursorPosition: position , mouseButton: .left)
            eventDown?.post(tap: .cghidEventTap)
        }
    }
    
    var isMoving = false
    
    func updateJoystick(){
        var moveDx = CGFloat(310)
        var moveDy = CGFloat(740)
        
        if buttons[Keycode.w]! == (true){
                moveDy = CGFloat(700)
            }
            if buttons[Keycode.s]! == (true){
                moveDy = CGFloat(800)
            }
            if buttons[Keycode.a]! == (true){
                moveDx = CGFloat(250)

            }
            if buttons[Keycode.d]! == (true) {
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
        DispatchQueue.main.async{
            let mousePos = NSEvent.mouseLocation
            let cursorPos = CGPoint(x: mousePos.x, y: NSScreen.main!.frame.maxY - mousePos.y)
       let nextPos = CGPoint(x: cursorPos.x + dx, y: cursorPos.y + dy)
           let startTap = CGEvent(mouseEventSource: self.source, mouseType: .leftMouseDown, mouseCursorPosition: cursorPos, mouseButton: .left)
           startTap?.post(tap: .cghidEventTap)
           let endTap = CGEvent(mouseEventSource: self.source, mouseType: .leftMouseDown, mouseCursorPosition: nextPos, mouseButton: .left)
           endTap?.post(tap: .cghidEventTap)
           }
        }
            
    func updateCamera(){
        var cameraDx = ZERO
        var cameraDy = ZERO
        
        if buttons[Keycode.downArrow]! == (true){
            cameraDy = CGFloat(10)
        }
        if buttons[Keycode.upArrow]! == (true){
            cameraDy = CGFloat(-10)
        }
        if buttons[Keycode.rightArrow]! == (true){
            cameraDx = CGFloat(10)
        }
        if buttons[Keycode.leftArrow]! == (true){
            cameraDx = CGFloat(-10)
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
    let ABILITY_BTN  = CGPoint(x: 1000, y: 800)
    let ATTACK_BTN  = CGPoint(x: 1100, y: 750)
    let BURST_BTN  = CGPoint(x: 890, y: 835)
    
    var shiftCounter = 0
    
    func updateButtons(){
        if buttons[Keycode.m]! == (true){
            performClick(point: RUN_BTN)
        }
        if buttons[Keycode.rightMouse]! == (true){
            performClick(point: ATTACK_BTN)
        }
        if buttons[Keycode.f]! == (true){
            performClick(point: ACTION_BTN)
        }
        if buttons[Keycode.space]! == (true){
            performClick(point: SPACE_BTN)
        }
        if buttons[Keycode.e]! == (true){
            performClick(point: ABILITY_BTN)
        }
        if buttons[Keycode.r]! == (true){
            performClick(point: BURST_BTN)
        }
    }
    
    func recordCommand(key: UInt16){
        let p = "\(counter) : \(key),"
        print(p)
    }
    
    var counter = UInt64(0)
    
    func updateCommands(){
      counter+=1
    }
    
    func initController(){
        source = CGEventSource.init(stateID: CGEventSourceStateID.combinedSessionState)
        source?.localEventsSuppressionInterval = 0
        performClick(point: SCREEN_CENTER)
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown)
        {
            if(self.buttons[UInt16($0.keyCode)] == false){
                self.recordCommand(key: UInt16($0.keyCode))
            }
            self.buttons[UInt16($0.keyCode)] =  (true)
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.rightMouseDown)
        {   _ in
            self.buttons[Keycode.rightMouse] = (true)
        }
    
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.rightMouseUp){
            _ in
            self.buttons[Keycode.rightMouse] = (false)
            }
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.keyUp){
            if(self.buttons[UInt16($0.keyCode)] == true){
                self.recordCommand(key: UInt16($0.keyCode))
            }
            self.buttons[UInt16($0.keyCode)] = (false)
            }
    }
  }
    
