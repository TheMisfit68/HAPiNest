//
//  LeafDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 30/01/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import LeafDriver

class LeafDelegate:LeafDriver, AccessoryDelegate, AccessorySource, CyclicPollable{
	
	var name: String = ""
	
	typealias AccessorySubclass = Accessory.ElectricCar

	var characteristicChanged: Bool = false
	
	func handleCharacteristicChange<T>(accessory: Accessory, service: Service, characteristic: GenericCharacteristic<T>, to value: T?) where T : CharacteristicValueType {
		let accessoryName = accessory.info.name.value!

			switch characteristic.type{
				case CharacteristicType.powerState:
					break
//				self.batteryChecker.getBatteryStatus()
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(accessoryName)")
			}
	}
	
	var hardwareFeedbackChanged:Bool = false

	
	func pollCycle() {
		//
	}
	
	
	
	
}

