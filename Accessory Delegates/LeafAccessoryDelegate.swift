//
//  LeafAccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 30/01/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import LeafDriver
import JVSwiftCore
import OSLog
import JVNetworking

class LeafAccessoryDelegate:LeafDriver, AccessoryDelegate, AccessorySource{
	
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
						LeafAccessoryDelegate.logger.warning( "Unhandled characteristic change for accessory \(accessory.info.name.value ?? "")")
				}
				
			case accessory.aircoService:
				
				switch characteristic.type{
					case CharacteristicType.powerState:
						
						setAirco = characteristic.value as! Bool
						
					default:
						LeafAccessoryDelegate.logger.warning( "Unhandled characteristic change for accessory \(accessory.info.name.value ?? "")")
				}
				
			default:
				LeafAccessoryDelegate.logger.warning( "Unhandled characteristic change for accessory \(accessory.info.name.value ?? "")")
		}
		
		
		
	}
	
	
	var hardwareFeedbackChanged:Bool = false
	
	
	func pollCycle() {
		
		if  let feedbackTimeStamp = batteryChecker.updateTimeStamp,
			let percentageRemaining = batteryChecker.percentageRemaining,
			let rangeRemaining = batteryChecker.rangeRemaining,
			let isConnected = batteryChecker.connectionStatus,
			let isCharging = batteryChecker.chargingStatus
		{
			
			// Send an MQTT-payload with the remaining battery charge
			self.mqttMessage = LeafMQTTMessage(timeStamp: feedbackTimeStamp.utcToLocal().localDateTimeString(), percentage: percentageRemaining, range: rangeRemaining, isConnected: isConnected, isCharging: isCharging)
			
			// Adjust the battery indicators
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
		
		// Reset the charging switch to off if the command was executed successfully.
		if let chargeSwitchOn = accessory.chargerService.powerState.value,
		   let chargingWasExecuted = charger.chargingWasExecuted{
			accessory.chargerService.powerState.value?.reset(chargeSwitchOn && chargingWasExecuted)
		}
		
		// Synchronize the AC switch if the feedback comes in.
		if let aircoIsRunning = acController.aircoIsRunning{
			accessory.aircoService.powerState.value = aircoIsRunning
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
