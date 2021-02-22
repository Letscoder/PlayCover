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
    
    var perform = [
        0 : 666
    ]
    
    var performMouse = [
        130 : CGPoint(x:878.3984375 , y:424.51171875),
        141 : CGPoint(x:878.3984375 , y:424.51171875),
        325 : CGPoint(x:786.54296875 , y:753.5546875),
        338 : CGPoint(x:786.54296875 , y:753.5546875),
        392 : CGPoint(x:786.54296875 , y:753.5546875),
        405 : CGPoint(x:786.54296875 , y:753.5546875),
        451 : CGPoint(x:786.54296875 , y:753.5546875),
        463 : CGPoint(x:786.54296875 , y:753.5546875),
        510 : CGPoint(x:786.54296875 , y:753.5546875),
        521 : CGPoint(x:786.54296875 , y:753.5546875),
        564 : CGPoint(x:786.54296875 , y:753.5546875),
        575 : CGPoint(x:786.54296875 , y:753.5546875),
        620 : CGPoint(x:786.54296875 , y:753.5546875),
        631 : CGPoint(x:786.54296875 , y:753.5546875),
        712 : CGPoint(x:869.12109375 , y:744.82421875),
        722 : CGPoint(x:869.12109375 , y:744.82421875),
        782 : CGPoint(x:869.12109375 , y:744.82421875),
        791 : CGPoint(x:869.12109375 , y:744.82421875)
    ]
    

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
            performClick(point: FIRST_BTN)
        }
        if buttons[Keycode.two]! == (true){
            performClick(point: SECOND_BTN)
        }
        if buttons[Keycode.three]! == (true){
            performClick(point: THIRD_BTN)
        }
        if buttons[Keycode.m]! == (true){
            performClick(point: RUN_BTN)
        }
        if buttons[Keycode.q]! == (true){
            performClick(point: ABILITY_BTN)
        }
        if buttons[Keycode.f]! == (true){
            performClick(point: ACTION_BTN)
        }
        if buttons[Keycode.space]! == (true){
            performClick(point: SPACE_BTN)
        }
        if buttons[Keycode.e]! == (true){
            performClick(point: ATTACK_BTN)
        }
        if buttons[Keycode.r]! == (true){
            performClick(point: BURST_BTN)
        }
        if buttons[Keycode.c]! == (true){
            performClick(point: SWIM_BTN)
        }
    }
    
    var commands = [String]()
    func recordCommand(key: UInt16){
        let p = "\(counter) : \(key),"
        commands.append(p)
    }
    var mouse = [String]()
    func recordMouse(loc: NSPoint){
        let p = "\(counter) : CGPoint(x:\(loc.x) , y:\(NSScreen.main!.frame.maxY - loc.y)),"
        mouse.append(p)
    }
    
    func printRecords(){
        commands.forEach{
         print($0)
        }
        print("---------------------------------------")
        mouse.forEach{
            print($0)
        }
    }
    
    var counter = UInt64(0)
    
    func updateCommands(){
        if let val = perform[Int(counter)] {
            if( buttons[UInt16(val)] != nil){
                buttons[UInt16(val)] = !buttons[UInt16(val)]!
            }
        }
        if let val = performMouse[Int(counter)] {
            if(buttons[Keycode.rightMouse]!){
                rightMouseUp(point: val)
            } else{
                rightMouseDown(point: val)
            }
        }
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
            if(self.buttons[UInt16($0.keyCode)] == false){
                self.recordCommand(key: UInt16($0.keyCode))
            }
            self.buttons[UInt16($0.keyCode)] =  (true)
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.rightMouseDown)
        {   _ in
            if(self.buttons[Keycode.rightMouse] == false){
                self.recordMouse(loc: NSEvent.mouseLocation)
            }
            self.buttons[Keycode.rightMouse] = (true)
        }
    
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.rightMouseUp){
            _ in
            if(self.buttons[Keycode.rightMouse] == true){
                self.recordMouse(loc: NSEvent.mouseLocation)
            }
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
    
