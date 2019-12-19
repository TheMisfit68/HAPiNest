//
//  AppDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 14/10/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Cocoa
import SwiftUI
import JVCocoa
import HAP

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.title = "HAPiNest testing dashboard 🛋"
        window.setFrameAutosaveName(window.title)
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        
        HomeKitServer.shared.bridge = Bridge(
            bridgeInfo: Service.Info(name: "NestBridge", serialNumber: "00001"),
            setupCode: Bridge.SetupCode("234-56-789"),
            storage: HomeKitServer.shared.configFile,
            accessories: myAccessories)
        
        let inverterData = JVSQLdbase.open(file: "InverterData.sqlite")
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}

