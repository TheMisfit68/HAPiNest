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
	
	public static var shared: MQTTClient = MQTTClient(autoSubscribeTo: ["HomeKit/ExternalEvents/ToServer"], autoPublishTo: ["HomeKit/ExternalEvents/FromServer"])

}
