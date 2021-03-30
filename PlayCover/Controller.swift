import SwiftUI
import Foundation
import UserNotifications
import SpriteKit
import Carbon.HIToolbox
import Cocoa
import RealmSwift


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
    
    // 0 - btn, 1 - rmd, 2 - rmu
    
    func performClick(point: CGPoint){
//        DispatchQueue.main.async {
//            let eventDown = CGEvent(mouseEventSource: self.source, mouseType: .leftMouseDown, mouseCursorPosition: point , mouseButton: .left)
//            let eventUp = CGEvent(mouseEventSource: self.source, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left)
//            eventDown?.post(tap: .cghidEventTap)
//            eventUp?.post(tap: .cghidEventTap)
//        }
        
        ExtensionEvent.post(x: Int(point.x), y: Int(point.y))
        
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

    private func leftMouseDown(direction: CGPoint){
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
            leftMouseDown(direction: CGPoint(x: moveDx, y: moveDy))
        } else{
            if(isMoving){
                leftMouseUp(direction: SCREEN_CENTER)
                isMoving = false
            }
        }
    }
    
    func leftMouseUp(direction: CGPoint){
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
            cameraDy = CGFloat(5)
        }
        if buttons[Keycode.upArrow]! == (true){
            cameraDy = CGFloat(-5)
        }
        if buttons[Keycode.rightArrow]! == (true){
            cameraDx = CGFloat(5)
        }
        if buttons[Keycode.leftArrow]! == (true){
            cameraDx = CGFloat(-5)
        }
        
        if(!cameraDx.isZero || !cameraDy.isZero){
            isCameraMoving = true
            cameraRotate(dx: cameraDx, dy: cameraDy)
        } else{
            if(isCameraMoving){
                leftMouseUp(direction: SCREEN_CENTER)
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
        } else if buttons[Keycode.two]! == (true){
            performClick(point: SECOND_BTN)
        }
        else if buttons[Keycode.three]! == (true){
            performClick(point: THIRD_BTN)
        }
        else if buttons[Keycode.m]! == (true){
            performClick(point: RUN_BTN)
        }
        else if buttons[Keycode.q]! == (true){
            performClick(point: ABILITY_BTN)
        }
        else if buttons[Keycode.f]! == (true){
            performClick(point: ACTION_BTN)
        }
        else if buttons[Keycode.space]! == (true){
            performClick(point: SPACE_BTN)
        }
        else if buttons[Keycode.e]! == (true){
            performClick(point: ATTACK_BTN)
        }
        else if buttons[Keycode.r]! == (true){
            performClick(point: BURST_BTN)
        }
        else if buttons[Keycode.c]! == (true){
            performClick(point: SWIM_BTN)
        }
    }
   
    
    func recordMouse(loc: NSPoint, type : Int){
        if(!perform){
            let record = RecordMacro(ts: Double(Double(counter) + stepCounter), type: type, key: 0x00, x: Int(loc.x), y: Int(NSScreen.main!.frame.maxY - loc.y))
            try! localRealm!.write {
                localRealm!.add(record, update: .modified)
            }
            stepCounter+=0.1
        }
        
    }
    
    func recordButton(keycode : UInt16){
        if (!perform){
            let record = RecordMacro(ts: Double(Double(counter) + stepCounter), type: 0, key: Int(keycode), x: 0, y: 0)
            try! localRealm!.write {
                localRealm!.add(record, update: .modified)
            }
            stepCounter+=0.1
        }
    }
    
    var counter = UInt64(0)
    var stepCounter = 0.0

    // 0 - btn, 1 - lmd, 2 - lmu, 3 - rmd, 4 - rmu
    
    let perform = false
    
    func updateCommands(){
        if(perform){
            
            if let val = localRealm?.object(ofType: RecordMacro.self, forPrimaryKey: "\(Double(counter))"){
                let point = CGPoint(x: val.x, y : val.y)
                switch(val.type){
                case 0: buttons[UInt16(val.key)] = !buttons[UInt16(val.key)]!; break;
                case 1: rightMouseDown(point: point)
                case 2: rightMouseUp(point: point)
                default: break;
                }
            }
            
            if let val = localRealm?.object(ofType: RecordMacro.self, forPrimaryKey: "\(Double(counter) + 0.1)"){
                let point = CGPoint(x: val.x, y : val.y)
                switch(val.type){
                case 0: buttons[UInt16(val.key)] = !buttons[UInt16(val.key)]!; break;
                case 1: rightMouseDown(point: point)
                case 2: rightMouseUp(point: point)
                default: break;
                }
            }
            
            if let val = localRealm?.object(ofType: RecordMacro.self, forPrimaryKey: "\(Double(counter) + 0.2)"){
                let point = CGPoint(x: val.x, y : val.y)
                switch(val.type){
                case 0: buttons[UInt16(val.key)] = !buttons[UInt16(val.key)]!; break;
                case 1: rightMouseDown(point: point)
                case 2: rightMouseUp(point: point)
                default: break;
                }
            }
        
        }
        stepCounter = 0
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
    
    var localRealm : Realm?
    var records : Results<RecordMacro>?
    
    func initController(){
        localRealm = try! Realm()
        if(!perform){
            try! localRealm!.write {
                localRealm!.deleteAll()
            }
        }
        records = localRealm!.objects(RecordMacro.self)
        source = CGEventSource.init(stateID: CGEventSourceStateID.combinedSessionState)
        source?.localEventsSuppressionInterval = 0
        performClick(point: SCREEN_CENTER)
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown)
        {
            if( self.buttons[UInt16($0.keyCode)] != true){
                self.recordButton(keycode: UInt16($0.keyCode))
                self.buttons[UInt16($0.keyCode)] =  (true)
            }
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.rightMouseDown)
        {   _ in
            if(self.buttons[Keycode.rightMouse] == false){
                self.recordMouse(loc: NSEvent.mouseLocation, type: 1)
            }
            self.buttons[Keycode.rightMouse] = (true)
        }
    
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.rightMouseUp){
            _ in
            if(self.buttons[Keycode.rightMouse] == true){
                self.recordMouse(loc: NSEvent.mouseLocation, type: 2)
            }
            self.buttons[Keycode.rightMouse] = (false)
            }
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.keyUp){
            if(self.buttons[UInt16($0.keyCode)] != false){
                self.recordButton(keycode: UInt16($0.keyCode))
                self.buttons[UInt16($0.keyCode)] = (false)
            }
            }
    }
  }
    
