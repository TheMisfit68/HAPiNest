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
import SoftPLC
import ModbusDriver

@available(OSX 11.0, *)
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    
    var homekitServer:HomeKitServer! = nil
    var plc:SoftPLC! = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        plc = SoftPLC(hardwareConfig:MainConfiguration.PLC.HardwareConfig, ioList: MainConfiguration.PLC.IOList)
        plc.plcObjects = MainConfiguration.PLC.PLCobjects
        plc.run()
        
        homekitServer = HomeKitServer.shared
        homekitServer.mainBridge = Bridge(
            name:MainConfiguration.HomeKit.BridgeName,
            setupCode:MainConfiguration.HomeKit.BridgeSetupCode
        )
        MainConfiguration.HomeKit.AddAccessories()
        
        
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
        
        homekitServer.leafDriver.batteryChecker.getBatteryStatus()
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

