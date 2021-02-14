import SwiftUI
import Foundation
import HotKey
import UserNotifications
import SpriteKit
import Carbon.HIToolbox

let FORWARD = CGPoint(x:310, y:700)
let BOTTOM = CGPoint(x: 310, y: 800)
let RIGHT = CGPoint(x: 350, y: 740)
let LEFT = CGPoint(x: 250, y: 740)
let CENTER = CGPoint(x: 310, y: 740)
let SCREEN_CENTER = CGPoint(x: 700, y: 600)

class Controller {
    
    private var mouseLocation: NSPoint { NSEvent.mouseLocation }
    
    let source = CGEventSource.init(stateID: .hidSystemState)
    
    var buttons = [
        Key.space : false,
        Key.e : false,
        Key.w : false,
        Key.s : false,
        Key.a : false,
        Key.d : false,
        Key.i : false
    ]

    func performClick(point: CGPoint){
        let eventDown = CGEvent(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: point , mouseButton: .left)
        let eventUp = CGEvent(mouseEventSource: source, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left)
        eventDown?.post(tap: .cghidEventTap)
        eventUp?.post(tap: .cghidEventTap)
    }

    func moveJoystick(direction: CGPoint){
        let position = direction
        let eventDown = CGEvent(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: position , mouseButton: .left)
        eventDown?.post(tap: .cghidEventTap)
    }
    
    var listenToMouse = true
    var mouseMoved = false
    
    func cameraStep(){
        if(mouseMoved){
            mouseMoved = false
            listenToMouse = false
               let startTap = CGEvent(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: CGPoint(x: mouseLocation.x, y: CGFloat(900) -  mouseLocation.y), mouseButton: .left)
                startTap?.post(tap: .cghidEventTap)
                let endTap = CGEvent(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: CGPoint(x: mouseLocation.x + CGFloat(1), y: CGFloat(900) -  mouseLocation.y) , mouseButton: .left)
                endTap?.post(tap: .cghidEventTap)
            listenToMouse = true
        }
    }
        
    func initController(){
        let ref = CGEventSource(stateID: CGEventSourceStateID.combinedSessionState);
        ref?.localEventsSuppressionInterval = 0
        performClick(point: SCREEN_CENTER)
        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
            if(self.listenToMouse){
                self.mouseMoved = true
            } else {
                self.mouseMoved = false
            }
        }
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
