//
//  MatterEventMQTTClient.swift
//  HAPiNest
//
//  Created by Jan Verrept on 29/01/2024.
//  Copyright © 2024 Jan Verrept. All rights reserved.
//

import Foundation
import MQTTNIO
import JVSwiftCore
import JVNetworking
import OSLog

extension MQTTClient {
	
	public static let mqttSettings:MQTTSettingsManager = MQTTSettingsManager()
	
	/// Convenience intitializer for the MQTTClient/Singleton used within this project
	convenience init() {
		self.init(
			host: MQTTClient.mqttSettings.host,
			port: MQTTClient.mqttSettings.portNumber,
			identifier: MainConfiguration.HomeKitServer.ServerName,
			eventLoopGroupProvider: .createNew,
			configuration: MQTTClient.mqttSettings.configuration
		)
	}
	
	/// Convenience method to subscribe to all Matter related events/topics, needed within this project.
	func subscribe() async throws{
		
		let matterEventsSubscription = MQTTSubscribeInfo(topicFilter: "HomeKit/ExternalEvents/ToServer/MatterEvents", qos: .exactlyOnce)
		
		_ = try await self.subscribe(to: [matterEventsSubscription])
		let listener = self.createPublishListener()
		for await result in listener {
			switch result {
				case .success(let publish):
					if publish.topicName == "HomeKit/ExternalEvents/ToServer/MatterEvents" {
						var buffer = publish.payload
						if let string:String = buffer.readString(length: buffer.readableBytes){
							let decoder = JSONDecoder()
							if let jsonData = string.data(using: .utf8){
								// Handle the Matter Event
								let event:MatterEvent = try decoder.decode(MatterEvent.self, from: jsonData)
								if let tag = event.tag{
									let localizedTag:String = String(localized: String.LocalizationValue(tag), table: "AccessoryNames")
									if let plcObject = MainConfiguration.PLC.PLCobjects[localizedTag] as? MatterEventDelegate{
										plcObject.syncAttribute(type: event.attributeType, value: event.attributeValue)
									}
								}
							}
						}
					}
				case .failure(let error):
					let logger = Logger(subsystem: "HAPiNest.MQTTClient", category: "MatterEvents")
					logger.error("Error while receiving Matter event: = \(error.localizedDescription, privacy: .public)")
			}
		}
	}
	
}


// MARK: - MatterEventDelegates
// Extensions for each accessory type to handle Matter events over MQTT.
protocol MatterEventDelegate: AnyObject {
	func syncAttribute(type: String, value: Int)
	var characteristicChanged:Bool { get set}
}

extension Light: MatterEventDelegate {
	
	func syncAttribute(type: String, value: Int) {
		
		switch type {
			case "onOff", "main":
				self.accessory.lightbulb.powerState.value = (value  == 1)
				characteristicChanged = true
			default:
				// Optionally log ignored attributes
				let logger = Logger(subsystem: "HAPiNest.MQTTClient", category: "MatterEvents")
				logger.warning("Ignored attribute: \(type)")
		}
	}
}

extension Outlet: MatterEventDelegate {
	
	func syncAttribute(type: String, value: Int) {
		
		switch type {
			case "onOff", "main":
				self.accessory.outlet.powerState.value = (value == 1)
				characteristicChanged = true
			default:
				let logger = Logger(subsystem: "HAPiNest.MQTTClient", category: "MatterEvents")
				logger.warning("Ignored attribute: \(type)")
		}
	}
}

extension WindowCovering: MatterEventDelegate {
	
	func syncAttribute(type: String, value: Int) {
		switch type {
			case "targetPosition":
				let newTarget = min(max(value, 0), 100)  // Clamp value between 0 and 100
				self.accessory.windowCovering.targetPosition.value = UInt8(newTarget)
				characteristicChanged = true
				
			default:
				let logger = Logger(subsystem: "HAPiNest.MQTTClient", category: "MatterEvents")
				logger.warning("Ignored attribute: \(type)")
		}
	}
}
