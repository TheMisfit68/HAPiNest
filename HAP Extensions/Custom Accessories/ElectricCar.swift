//
//  ElectricCar.swift
//  HAPiNest
//
//  Created by Jan Verrept on 08/01/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import HAP

extension Accessory {
	
	open class ElectricCar: Accessory{
		
		public let battery:Service.Battery
		public let airco:Service.Thermostat

		
		public init( info: Service.Info,
					 additionalServices: [Service] = []
		) {
			battery = Service.Battery(characteristics: [.statusLowBattery(.batteryNormal),.chargingState(.charging),.batteryLevel(95), .name("testBatterij")])
			airco = Service.Thermostat(characteristics: [.targetTemperature(18), .currentTemperature(10), .targetHeaterCoolerState(.heatAuto), .currentHeaterCoolerState(.idle), .temperatureDisplayUnits(.celcius)])
			
			super.init(info: info, type: .other, services: [battery, airco] + additionalServices)
		}
		
	}
}
