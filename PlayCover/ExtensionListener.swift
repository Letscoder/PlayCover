//
//  ExtensionListener.swift
//  PlayCoverPatcher
//
//  Created by Alex on 30.03.2021.
//

import Foundation

final public class ExtensionListener: NSObject {

    // the inter-process NotificationCenter
    private let center = CFNotificationCenterGetDarwinNotifyCenter()
    private var listenersStarted = false
    fileprivate static let notificationName = "keymapper.playcover.touch" as CFString

    public override init() {
        super.init()
        // listen for an action in the Share Extension
        startListeners()
    }

    deinit {
        // don't listen anymore
        stopListeners()
    }
    
   
    
    //    MARK: listening
    fileprivate func startListeners() {
        if !listenersStarted {
            self.listenersStarted = true
            CFNotificationCenterAddObserver(center, Unmanaged.passRetained(self).toOpaque(), { (center, observer, name, object, userInfo) in
                
    
            }, Self.notificationName, nil, .deliverImmediately)
        }
    }

    fileprivate func stopListeners() {
        if listenersStarted {
            CFNotificationCenterRemoveEveryObserver(center, Unmanaged.passRetained(self).toOpaque())
            listenersStarted = false
        }
    }
}

final public class ExtensionEvent: NSObject {
    public static func post(x: Int, y:Int) {
        UserDefaults.standard.set(x, forKey: "x")
        UserDefaults.standard.set(y, forKey: "y")
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFNotificationName(rawValue: ExtensionListener.notificationName), nil, nil, true)
    }
}
