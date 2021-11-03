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
import ModbusDriver

@main
struct HAPiNestApp: App {
	@Environment(\.scenePhase) var scenePhase
	
	static var InDeveloperMode:Bool{
		return (Host.current().localizedName ?? "") == "MacBook Pro"
	}
	
	init() {
		
		AppState.shared.plc.plcObjects = MainConfiguration.PLC.PLCobjects
		
		var bridgename = MainConfiguration.HomeKit.BridgeName
		var setupCode = MainConfiguration.HomeKit.BridgeSetupCode
		var configFile = MainConfiguration.HomeKit.BridgeConfigFile
		#if DEBUG
		if HAPiNestApp.InDeveloperMode{
			bridgename 	= "development\(bridgename)"
			setupCode 	= "012-34-567"
			configFile 	= "development\(configFile)"
		}
		#endif
		
		AppState.shared.homekitServer.mainBridge = Bridge(
			name:bridgename,
			setupCode:setupCode,
			accessories: MainConfiguration.HomeKit.Accessories.map{$0.0},
			configfileName: configFile
		)

		#if DEBUG
		AppState.shared.plc.executionType = HAPiNestApp.InDeveloperMode ? .simulated(withHardware:true) : .normal
		#else
		AppState.shared.plc.executionType = .normal
		#endif
		
		// Only fire Up PLC after all components are initialized
		AppState.shared.plc.run()
		
		// Start an extra background cycle indepedent of the PLCs backroundCycle
		// (to poll for harware changes on behalf of the other type acessoryDelegates)
		AppState.shared.cyclicPoller.run()
		
	}
	
	
	var body: some Scene {
		WindowGroup("HAPiNest dashboard 🛋") {
			DashBoardView()
				.onAppear(perform: {
					//                    AppState.shared.homekitServer.leafDriver.batteryChecker.getBatteryStatus()
				})
		}
		.onChange(of: scenePhase) { newScenePhase in
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
			DashBoardView()
		}
		#endif
	}
	
}

// In Apps with a swiftUI lifecyle,
// APP is a struct wich can't be presented as a singleton and therefore that can't be referenced globally
// Appstate however is a singleton and therefore can get referenced globally
class AppState:Singleton{
	
	static let shared:AppState = AppState()
	let appNapController: AppNapController = AppNapController.shared
	
	let homekitServer:HomeKitServer = HomeKitServer.shared
	let cyclicPoller:CyclicPoller = CyclicPoller(timeInterval: 1.0)
	let plc:SoftPLC = SoftPLC(hardwareConfig:MainConfiguration.PLC.HardwareConfig, ioList: MainConfiguration.PLC.IOList, simulator:ModbusSimulator())
	
	private init(){}
}

