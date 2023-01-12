//
//  StatelessGarageDoorOpenerAccessory.swift
//  HAPiNest
//
//  Created by Jan Verrept on 11/01/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import Foundation
import HAP

extension Accessory.GarageDoorOpener {
	
	open class StatelessGarageDoorOpener: Accessory{
		
		public let toggleButton:Service.Switch
		
		public init( info: Service.Info,
					 additionalServices: [Service] = []
		) {
			toggleButton = Service.Switch()
			super.init(info: info, type: .garageDoorOpener, services: [toggleButton] + additionalServices)
		}
		
	}
}
