//
//  SmartSprinklerAccessory.swift
//  HAPiNest
//
//  Created by Jan Verrept on 11/01/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import Foundation
import HAP

// There is no predefinied Sprinkler Acccessory yet,
// so just extend on the Accessory-Class itself instead of embedding it
//extension Accessory {
//
//	open class SmartSprinkler: Accessory {
//
//		public let enableSwitch:Service.Switch.EnableSwitch
//		public let irrigationSystem:Service.IrrigationSystem
//
//		public init( info: Service.Info,
//					 additionalServices: [Service] = []
//		) {
//			irrigationSystem = Service.IrrigationSystem()
//			enableSwitch = Service.Switch.EnableSwitch()
//			super.init(info: info, type: .sprinkler, services:[irrigationSystem,enableSwitch])
//		}
//	}
//}

extension Accessory {
	class SmartSprinkler: Accessory  {
		let maineservice = Service.IrrigationSystem(characteristics:[ .name("Sproeiers"), .active(.inactive),.programMode(1),.inUse(1)])
		init(info: Service.Info) {
			super.init(info: info, type: .sprinkler, services: [maineservice])
		}
	}
}
