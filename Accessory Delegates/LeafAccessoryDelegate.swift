//
//  LeafAccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 30/01/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVSwift
import LeafDriver
import OSLog
import JVNetworking

class LeafAccessoryDelegate:LeafDriver, AccessoryDelegate, AccessorySource{
	let logger = Logger(subsystem: "be.oneclick.HAPiNest", category: "LeafAccessoryDelegate")
	
	var name: String{
		return String(localized:"Electric Car")
	}
	
	typealias AccessorySubclass = Accessory.ElectricCar
	
	var characteristicChanged: Bool = false
	
	let lowChargeLimit = 15
	
	
	public override init(leafProtocol: LeafProtocol) {
		
		super.init(leafProtocol: leafProtocol)
		
	}
	
	var startCharging:Bool = false{
		didSet{
			if startCharging{
				self.charger.startCharging()
			}
		}
	}
	
	var setAirco:Bool = false{
		didSet{
			if setAirco{
				self.acController.setAirCo(to: .on)
			}else{
				self.acController.setAirCo(to: .off)
				
			}
		}
	}
	
	var mqttMessage:LeafMQTTMessage? = nil{
		didSet{
			guard mqttMessage != nil else {return}
			if mqttMessage != oldValue{
				MQTTClient.shared.publish(topic: "HomeKit/ExternalEvents/FromServer/NissanLeaf", type: mqttMessage!, retained: true)
			}
		}
	}
	
	func handleCharacteristicChange<T>(accessory: AccessorySubclass, service: Service, characteristic: GenericCharacteristic<T>, to value: T?) where T : CharacteristicValueType {
		
		switch service {
			case accessory.chargerService:
				
				switch characteristic.type{
					case CharacteristicType.powerState:
						
						startCharging = characteristic.value as! Bool
						
					default:
						logger.warning( "Unhandled characteristic change for accessory \(accessory.info.name.value ?? "")")
				}
				
			case accessory.aircoService:
				
				switch characteristic.type{
					case CharacteristicType.powerState:
						
						setAirco = characteristic.value as! Bool
						
					default:
						logger.warning( "Unhandled characteristic change for accessory \(accessory.info.name.value ?? "")")
				}
				
			default:
				logger.warning( "Unhandled characteristic change for accessory \(accessory.info.name.value ?? "")")
		}
		
		
		
	}
	
	
	var hardwareFeedbackChanged:Bool = false
	
	
	func pollCycle() {
		
		if  let percentageRemaining = batteryChecker.percentageRemaining,
			let rangeRemaining = batteryChecker.rangeRemaining,
			let isConnected = batteryChecker.connectionStatus,
			let isCharging = batteryChecker.chargingStatus
		{
			
			// Send an MQTT-payload
			let timeStamp = batteryChecker.updateTimeStamp!
			self.mqttMessage = LeafMQTTMessage(timeStamp: timeStamp.localDateTimeString(), percentage: percentageRemaining, range: rangeRemaining, isConnected: isConnected, isCharging: isCharging)
			
			// Chang the state of the accessory
			accessory.primaryService.batteryLevel?.value =  UInt8(percentageRemaining)
			if  (percentageRemaining >= lowChargeLimit){
				accessory.primaryService.statusLowBattery.value = .batteryNormal
			}else{
				accessory.primaryService.statusLowBattery.value = .batteryLow
			}
			if isConnected{
				accessory.primaryService.chargingState?.value = isCharging ? .charging : .notCharging
			}else{
				accessory.primaryService.chargingState?.value = .notChargeable
			}
			
		}
		
		
	}
	
}

public struct LeafMQTTMessage:Codable, Equatable{
	
	let timeStamp: String
	let percentage: Int
	let range: Int
	let isConnected: Bool
	let isCharging: Bool
	
}
