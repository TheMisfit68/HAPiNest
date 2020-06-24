//
//  AppDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 14/10/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//
import Foundation
import Cocoa
import SwiftUI
import JVCocoa
import HAP

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        HomeKitServer.shared.bridge = Bridge(
            bridgeInfo: Service.Info(name: bridgeName, serialNumber: "00001"),
            setupCode: Bridge.SetupCode(stringLiteral: bridgeSetupCode),
            storage: HomeKitServer.shared.configFile,
            accessories: myAccessories)
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.title = "HAPiNest dashboard 🛋"
        window.setFrameAutosaveName(window.title)
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

