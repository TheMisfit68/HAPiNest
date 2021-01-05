//
//  LeafDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 14/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import LeafDriver

extension LeafDriver:AccessoryDelegate{
    
    func handleCharacteristicChange<T>(
        
        _ accessory: Accessory,
        _ service: Service,
        _ characteristic: GenericCharacteristic<T>,
        _ value:T?
    ){
        
        let accessoryName = accessory.info.name.value!
            
            switch characteristic.type{
            case CharacteristicType.powerState:
                self.batteryChecker.getBatteryStatus()
            default:
                Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(accessoryName)")
            }
        }

}
