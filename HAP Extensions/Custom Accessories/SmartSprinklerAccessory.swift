//
//  SmartSprinklerAccessory.swift
//  HAPiNest
//
//  Created by Jan Verrept on 11/01/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import Foundation
import HAP

extension Accessory {
    
    class SmartSprinkler:Accessory{
        
        let primaryService:Service.IrrigationSystem = Service.IrrigationSystem(characteristics: [.name(String(localized:"Sprinklers",table: "ServiceNames"))])

        let enableAutoService:Service.Switch.EnableSwitch = Service.Switch.EnableSwitch()
        let manualOverrideService:Service.Switch = Service.Switch(characteristics: [.name(String(localized:"Manual",table: "ServiceNames"))])

		init(info: Service.Info) {
            super.init(info: info, type: .sprinkler, services: [primaryService, enableAutoService, manualOverrideService])
		}
	}
    
}
