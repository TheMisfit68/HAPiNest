//
//  HAPiNestApp.swift
//  HAPiNest
//
//  Created by Jan Verrept on 26/11/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI
import JVCocoa
import HAP
import SoftPLC
import SwiftUI

@main
struct HAPiNestApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        
        AppState.shared.plc.plcObjects = MainConfiguration.PLC.PLCobjects
        AppState.shared.plc.run()
        
        AppState.shared.homekitServer.mainBridge = Bridge(
            name:MainConfiguration.HomeKit.BridgeName,
            setupCode:MainConfiguration.HomeKit.BridgeSetupCode)
        
        MainConfiguration.HomeKit.AddAccessories()
        
    }
    
    var body: some Scene {
        WindowGroup("HAPiNest dashboard 🛋") {
            DashBoardView()
                .onAppear(perform: {
                    AppState.shared.homekitServer.leafDriver.batteryChecker.getBatteryStatus()
                })
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("App became active")
            case .inactive:
                print("App became inactive")
            case .background:
                print("App sent to background")
            @unknown default:
                break
            }
        }
        
        // PrefereceWindow
        #if os(macOS)
        Settings{
        }
        #endif
    }
}

class AppState:Singleton{
    
    static let shared:AppState = AppState()
    let plc:SoftPLC = SoftPLC(hardwareConfig:MainConfiguration.PLC.HardwareConfig, ioList: MainConfiguration.PLC.IOList)
    let homekitServer:HomeKitServer = HomeKitServer.shared
    
}
