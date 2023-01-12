//
//  Bridge.swift
//  HAPiNest
//
//  Created by Jan Verrept on 17/11/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import SoftPLC


typealias Bridge = Device

extension Bridge{
	
	static let serialNumber = "00001"
	static var configFile:Storage!
	
	convenience init(name:String, setupCode:String, accessories:[HAP.Accessory], configfileName:String) {
		
		// Use the Application support folder to hold the HAP-configuration-data
		let fileManager = FileManager.default
		if let hapSupportDir = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("HAP"){
			
			fileManager.checkForDirectory(hapSupportDir,createIfNeeded: true)
			let configFile = hapSupportDir.appendingPathComponent(configfileName)
			Self.configFile = FileStorage(filename:configFile.path)
			
			// Create an Alias for easy access
			let homeDir = FileManager.default.homeDirectoryForCurrentUser
			let aliasURL = homeDir.appendingPathComponent("HAP-Data")
			if !fileManager.fileExists(atPath: aliasURL.path){
				fileManager.createAlias(from: hapSupportDir, at: aliasURL)
			}
			
		}
		
		self.init(
			bridgeInfo: Service.Info(name: name, serialNumber: Self.serialNumber),
			setupCode: Device.SetupCode(stringLiteral: setupCode),
			storage: Self.configFile,
			accessories: accessories
		)
		
		printPairingInstructions()
		
		// Set the delegate for the bridge itself and for the individual accessories
		delegate = self
		MainConfiguration.HomeKit.Accessories.forEach{accessory, delegate in
			accessory.delegate = delegate
			
			if (delegate as? PLCClass) != nil,
				let plcBasedDelegate = (MainConfiguration.PLC.PLCobjects[accessory.name] as? AccessoryDelegate){
				// Set the delegate to the PLC-object (and with a name equal the accessories name)
				accessory.delegate = plcBasedDelegate
			}
		}
	}
	
	// MARK: - Pairing Info
	
	public func printPairingInstructions(){
		if isPaired {
			print()
			Debugger.shared.log(debugLevel: .Succes, "The bridge is paired, unpair using your iPhone.")
			print()
		} else {
			print()
			Debugger.shared.log(debugLevel: .Native(logType:.info), "Scan the following QR code using your iPhone to pair this bridge:")
			print()
			print(setupQRCode.asText)
			print(setupCode)
			print()
		}
	}
	
	public func resetPairingInfo(){
		Debugger.shared.log(debugLevel: .Native(logType:.info), "Dropping all pairings, keys")
		try? Self.configFile.write(Data())
	}
	
	subscript(accessoryName: String) -> Accessory?{
		return accessories.first(where: {$0.info.name.value == accessoryName })
	}
	
	public func removeAccessoryWith(SerialNumbers:[String]){
		
		let unwantedAccessories = accessories.filter{SerialNumbers.contains($0.info.serialNumber.value!)}
		removeAccessories(unwantedAccessories, andForgetSerialNumbers: true)
		
	}
	
}

