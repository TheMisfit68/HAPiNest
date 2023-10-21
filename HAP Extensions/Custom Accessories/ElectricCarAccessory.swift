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
	
    class ElectricCar: Accessory{
		
        let primaryService:Service.Battery = Service.Battery(characteristics: [.name(String(localized: "Battery status",table: "ServiceNames"))])
        let chargerService:Service.Switch = Service.Switch(characteristics: [.name(String(localized: "Start Charging",table: "ServiceNames"))])
        let aircoService:Service.Switch = Service.Switch(characteristics: [.name(String(localized: "Start Airco",table: "ServiceNames"))])

		public init(info: Service.Info) {
			super.init(info: info, type: .other, services: [primaryService, chargerService, aircoService])
		}
		
	}
}
