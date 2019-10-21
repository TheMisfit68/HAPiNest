//
//  AppDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 14/10/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Cocoa
import SwiftUI
import MilightDriver

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
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        

        let testDriver =  MilightDriverV6(ipAddress: "192.168.0.52")
        testDriver.findBridge()
        testDriver.execute(mode:.rgbw, action:.on, value: 12, zone:.zone02)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

