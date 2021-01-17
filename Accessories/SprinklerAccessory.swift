//
//  SmartSprinklerAccessory.swift
//  HAPiNest
//
//  Created by Jan Verrept on 11/01/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import Foundation
import HAP

// MARK: - Accessory definition

extension Accessory {
    
    open class SmartSprinkler: Accessory {
        
        let irrigationSystem = Service.IrrigationSystem()
        let additionalServices = [Service.Switch()]

        public init(info: Service.Info) {
            super.init(info: info, type: .sprinkler, services: [irrigationSystem] + additionalServices)
        }
    }
}

extension Service {
    open class IrrigationSystem: IrrigationSystemBase {
    }
}
