import SwiftUI
import Foundation
import UserNotifications
import SpriteKit
import Carbon.HIToolbox
import Cocoa

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
        Keycode.r: false,
        Keycode.q: false,
        Keycode.one: false,
        Keycode.two: false,
        Keycode.three: false,
        Keycode.c: false
    ]
    
    class Record {
        var point = CGPoint(x: 0,y: 0)
        var btn = false
        init(point : CGPoint, btn: Bool = false){
            self.point = point
            self.btn = btn
        }
    }
    func performClick(point: CGPoint){
        DispatchQueue.main.async {
            let eventDown = CGEvent(mouseEventSource: self.source, mouseType: .leftMouseDown, mouseCursorPosition: point , mouseButton: .left)
            let eventUp = CGEvent(mouseEventSource: self.source, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left)
            eventDown?.post(tap: .cghidEventTap)
            eventUp?.post(tap: .cghidEventTap)
        }
    }
    
    func rightMouseUp(point: CGPoint){
        DispatchQueue.main.async {
            let eventUp = CGEvent(mouseEventSource: self.source, mouseType: .rightMouseUp, mouseCursorPosition: point, mouseButton: .right)
            eventUp?.post(tap: .cghidEventTap)
        }
    }
    
    func rightMouseDown(point: CGPoint){
        DispatchQueue.main.async {
            let eventDown = CGEvent(mouseEventSource: self.source, mouseType: .rightMouseDown, mouseCursorPosition: point , mouseButton: .right)
            eventDown?.post(tap: .cghidEventTap)
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
    
    let FIRST_BTN  = CGPoint(x: 1260, y: 372)
    let SECOND_BTN  = CGPoint(x: 1260, y: 440)
    let THIRD_BTN  = CGPoint(x: 1260, y: 500)
    
    let SWIM_BTN  = CGPoint(x: 1230, y:800)
    
    var shiftCounter = 0
    
    func updateButtons(){
        if buttons[Keycode.one]! == (true){
            recordMouse(loc: FIRST_BTN, btn: true)
            performClick(point: FIRST_BTN)
        }
        if buttons[Keycode.two]! == (true){
            recordMouse(loc: SECOND_BTN, btn: true)
            performClick(point: SECOND_BTN)
        }
        if buttons[Keycode.three]! == (true){
            recordMouse(loc: THIRD_BTN, btn: true)
            performClick(point: THIRD_BTN)
        }
        if buttons[Keycode.m]! == (true){
            recordMouse(loc: RUN_BTN, btn: true)
            performClick(point: RUN_BTN)
        }
        if buttons[Keycode.q]! == (true){
            recordMouse(loc: ABILITY_BTN, btn: true)
            performClick(point: ABILITY_BTN)
        }
        if buttons[Keycode.f]! == (true){
            recordMouse(loc: ACTION_BTN, btn: true)
            performClick(point: ACTION_BTN)
        }
        if buttons[Keycode.space]! == (true){
            recordMouse(loc: SPACE_BTN, btn: true)
            performClick(point: SPACE_BTN)
        }
        if buttons[Keycode.e]! == (true){
            recordMouse(loc: ATTACK_BTN, btn: true)
            performClick(point: ATTACK_BTN)
        }
        if buttons[Keycode.r]! == (true){
            recordMouse(loc: BURST_BTN, btn: true)
            performClick(point: BURST_BTN)
        }
        if buttons[Keycode.c]! == (true){
            recordMouse(loc: SWIM_BTN, btn: true)
            performClick(point: SWIM_BTN)
        }
    }
   
    func recordMouse(loc: NSPoint, btn: Bool){
        
        print("\(counter) : Record(point: CGPoint(x: \(loc.x) , y: \(NSScreen.main!.frame.maxY - loc.y)), btn: \(btn)),")
    }
    
    var counter = UInt64(0)
    
    func updateCommands(){
//        if let val = perform[Int(counter)] {
//            if(val.btn){
//                performClick(point: val.point)
//            } else{
//                if(buttons[Keycode.rightMouse]!){
//                    rightMouseUp(point: val.point)
//                } else{
//                    rightMouseDown(point: val.point)
//                }
//            }
//
//        }
        counter+=1
    }
    
    func test(){
        let cfMachPort = CGEvent.tapCreate(tap: CGEventTapLocation.cghidEventTap,
                                           place: CGEventTapPlacement.headInsertEventTap,
                                           options: CGEventTapOptions.defaultTap,
                                           eventsOfInterest: UINT64_MAX,
                                           callback: {(eventTapProxy, eventType, event, mutablePointer) -> Unmanaged<CGEvent>? in event
                                        
                                            let cocoaEventType = NSEvent.EventType(rawValue: UInt(eventType.rawValue))

                                                if [ NSEvent.EventType.gesture ].contains(cocoaEventType) {
                                                    let cocoaEvent = NSEvent(cgEvent: event)
                                                    let touches = cocoaEvent?.allTouches()
                                                    if let tt = touches {
                                                        for (i,t) in tt.enumerated() {
                                                            let x = NSString(format: "%.2f", t.normalizedPosition.x)
                                                            let y = NSString(format: "%.2f", t.normalizedPosition.y)
                                                           
                                                            print("Touches [\(i)] x:\(x) y:\(y)")
                                                          
                                                        }
                                                    }
                                                }
                                            
                                            return Unmanaged.passUnretained(event)
        }, userInfo: nil)

        let runloopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, cfMachPort!, 0)

        let runLoop = RunLoop.current
        let cfRunLoop = runLoop.getCFRunLoop()
        CFRunLoopAddSource(cfRunLoop, runloopSource, CFRunLoopMode.defaultMode)
    }
    
    func initController(){
 
        source = CGEventSource.init(stateID: CGEventSourceStateID.combinedSessionState)
        source?.localEventsSuppressionInterval = 0
        performClick(point: SCREEN_CENTER)
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown)
        {
            self.buttons[UInt16($0.keyCode)] =  (true)
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.rightMouseDown)
        {   _ in
            if(self.buttons[Keycode.rightMouse] == false){
                self.recordMouse(loc: NSEvent.mouseLocation,btn: false)
            }
            self.buttons[Keycode.rightMouse] = (true)
        }
    
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.rightMouseUp){
            _ in
            if(self.buttons[Keycode.rightMouse] == true){
                self.recordMouse(loc: NSEvent.mouseLocation, btn: false)
            }
            self.buttons[Keycode.rightMouse] = (false)
            }
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.keyUp){
            self.buttons[UInt16($0.keyCode)] = (false)
            }
    }
  }
    
