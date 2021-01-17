//
//  BasicGarageDoorAccessory.swift
//  HAPiNest
//
//  Created by Jan Verrept on 11/01/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import Foundation
import HAP

// MARK: - Accessory definition

extension Accessory.GarageDoorOpener {
    
    open class Basic: Accessory {
        
        public let primaryService = Service.BasicGarageDoorOpener()
        
        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .garageDoorOpener, services: [primaryService] + additionalServices)
        }
    }
}

extension Service {
    open class BasicGarageDoorOpener:Service{
        
        public let on = GenericCharacteristic<Bool>(
            type: .powerState,
            value: false)
        public let inUse = GenericCharacteristic<Bool>(
            type: .outletInUse,
            value: true,
            permissions: [.read, .events])
        public let batteryLevel = GenericCharacteristic<Double>(
            type: .batteryLevel,
            value: 100,
            permissions: [.read, .events])
        
        init() {
            super.init(type: .outlet, characteristics: [
                AnyCharacteristic(on),
                AnyCharacteristic(inUse),
                AnyCharacteristic(batteryLevel)
            ])
        }
        
    }
}


