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
import OSLog
import JVCocoa
import HAP
import SoftPLC
import ModbusDriver

@main
struct HAPiNestApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    let appNapController: AppNapController = AppNapController.shared
    
    let homekitServer:HomeKitServer = HomeKitServer.shared
    let plc:SoftPLC = SoftPLC(hardwareConfig:MainConfiguration.PLC.HardwareConfig, ioList: MainConfiguration.PLC.IOList, simulator:ModbusSimulator())
    let cyclicPoller:CyclicPoller = CyclicPoller(timeInterval: 1.0)
    
    init() {
        
        plc.plcObjects = MainConfiguration.PLC.PLCobjects
        
        let bridgename = MainConfiguration.HomeKitServer.BridgeName
        let setupCode = MainConfiguration.HomeKitServer.BridgeSetupCode
        let configFile = MainConfiguration.HomeKitServer.BridgeConfigFile
        
        homekitServer.mainBridge = Bridge(
            name:bridgename,
            setupCode:setupCode,
            accessories: MainConfiguration.Accessories.map{accessory, delegate in return accessory},
            configfileName: configFile
        )
        
#if DEBUG
        plc.toggleSimulator(true)
        plc.toggleHardwareSimulation(true)
#else
        plc.toggleSimulator(false)
#endif
        
        // Only fire Up PLC after all components are initialized
        plc.run()
        
        // Start an extra background cycle indepedent of the PLCs backroundCycle
        // (to poll for harware changes on behalf of the other type acessoryDelegates)
        cyclicPoller.run()
        
    }
    
    
    var body: some Scene {
        WindowGroup("HAPiNest dashboard 🛋") {
            DashboardView(
                serverView: homekitServer.dashboard!,
                plcView: plc.controlPanel
            )
            .padding()
            .background(Color.Neumorphic.main)
            .onAppear(perform: {
            })
        }
        .onChange(of: scenePhase) { newScenePhase in
            let logger = Logger(subsystem: "be.oneclick.HAPiNest", category:.lifeCycle)
            switch newScenePhase {
            case .active:
                logger.info("App became active")
            case .inactive:
                logger.info("App became inactive")
            case .background:
                logger.info("App sent to background")
            @unknown default:
                break
            }
        }
        
        // PreferenceWindow
#if os(macOS)
        Settings{
            PreferencesView()
        }
#endif
    }
    
}


