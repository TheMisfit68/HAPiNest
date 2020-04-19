//
//  TizenDriver.swift
//  HAPiNest
//
//  Created by Jan Verrept on 03/03/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import TizenDriver
import JVCocoa

extension TizenDriver:AccessoryDelegate{
    
    func handleCharacteristicChange<T>(
        
        _ accessory: Accessory,
        _ service: Service,
        _ characteristic: GenericCharacteristic<T>,
        _ value:T?
    ){
        if let accessoryName = accessory.info.name.value{
            
            // Define additional addressing based on the accessoryname
            switch accessoryName {
            case "T.V.":
                if characteristic is HAP.GenericCharacteristic<HAP.Enums.Active>{
                    let status = value as! HAP.Enums.Active
                    switch status{
                    case .active:
                        self.powerState = .poweringUp
                    case .inactive:
                        self.powerState = .poweringDown
                    }
                }
                
                if characteristic is HAP.GenericCharacteristic<Swift.UInt32>{
                    let channelNumber = value as! UInt32
                    switch channelNumber {
                    default:
                        if let keyCommand = TizenCommand(rawValue:"KEY_\(channelNumber)"){
                            queue(commands:[keyCommand])
                        }
                    }
                }
            case "T.V. boven":
                break
            default:
                JVDebugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
            }
            
        }
    }
}
