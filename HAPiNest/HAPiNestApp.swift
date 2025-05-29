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
import JVSwift
import JVSwiftCore
import JVNetworking
import JVScripting
import HAP
import SoftPLC
import ModbusDriver
import MQTTNIO

/// The main App that sets up a HomeKit-server together with its HomeKit-bridge
/// and a number of hardwaredrivers that will act as Accessory-delegates.
/// The hardwaredrivers/Accessory-delegates react to changes made to an accessory when it is controlled in the Home-app,
/// by translating those changes into actions for the hardware.
/// The main accessory-delegate in this App is a SoftPLC that can interact with the outside world by means of a number of Input and Output-modules.
@main
struct HAPiNestApp: App, Loggable {
	@SwiftUI.Environment(\.scenePhase) var scenePhase
	
	let appcontroller:AppController = AppController(name: "HAPiNest", terminal: TerminalDriver())
	let appNapController: AppNapController = AppNapController.shared
	
	let homekitServer:HomeKitServer = HomeKitServer.shared
	
	let mqttCLient =  MQTTClient()
	
	let plc:SoftPLC = SoftPLC(hardwareConfig:MainConfiguration.PLC.HardwareConfig, ioList: MainConfiguration.PLC.IOList, simulator:ModbusSimulator())
	let cyclicPoller:CyclicPoller = CyclicPoller(timeInterval: 1.0)
	
	init() {
		// Prevent running multiple instances of this App at all times
		appcontroller.killOldAppInstances()
		
		let bridgename = MainConfiguration.HomeKitServer.BridgeName
		let setupCode = MainConfiguration.HomeKitServer.BridgeSetupCode
		let configFile = MainConfiguration.HomeKitServer.BridgeConfigFile
		
		homekitServer.mainBridge = Bridge(
			name:bridgename,
			setupCode:setupCode,
			accessories: MainConfiguration.Accessories.map{accessory, delegate in return accessory},
			configfileName: configFile
		)
		
		plc.plcObjects = MainConfiguration.PLC.PLCobjects
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
			.task {
				let logger = Logger(subsystem: "be.oneclick.HAPiNest", category:.lifeCycle)
				do {
					try await mqttCLient.connect()
					try await mqttCLient.subscribe()
					logger.info("✅ 🔗 Succesfully connected MQTT client to broker")
				} catch {
					logger.error("❌ Error while connecting MQTT client to broker \(error)")
				}			}
			.onDisappear(perform:
							{ mqttCLient.disconnect() }
			)
		}
		.onChange(of: scenePhase) {
			let logger = Logger(subsystem: "be.oneclick.HAPiNest", category:.lifeCycle)
			switch scenePhase {
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


