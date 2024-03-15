//
//  MQTTClient.swift
//  HAPiNest
//
//  Created by Jan Verrept on 29/01/2024.
//  Copyright © 2024 Jan Verrept. All rights reserved.
//

import Foundation
import JVSwiftCore
import JVNetworking

extension MQTTClient:Singleton{
	
	/// Convenience intitializer for the MQTTClient/Singleton  used within this project
	public static var shared: MQTTClient = MQTTClient(name:MainConfiguration.HomeKitServer.ServerName, autoSubscribeTo: ["HomeKit/ExternalEvents/ToServer"], autoPublishTo: ["HomeKit/ExternalEvents/FromServer"])

}
