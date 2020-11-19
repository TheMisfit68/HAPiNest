//
//  MilightDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 03/12/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import MilightDriver
import os.log

@available(OSX 11.0, *)
extension MilightDriver:AccessoryDelegate{
    
    func handleCharacteristicChange<T>(
        
        _ accessory: Accessory,
        _ service: Service,
        _ characteristic: GenericCharacteristic<T>,
        _ value:T?
    ){
        
        let accessoryName = accessory.info.name.value!
        
        // Define additional addressing based on the accessoryname
        var zone:MilightZone?{
            switch accessoryName {
            case "Balk":
                return MilightZone.zone01
            case "UFO":
                return MilightZone.zone02
            default:
                Debugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
                return nil
            }
        }
        
        // Handle Characteristic change depending on its type
        if let zone = zone{
            
            switch characteristic.type{
            case CharacteristicType.powerState:
                
                let poweredOn = characteristic.value as! Bool
                let action = poweredOn ? MilightAction.on : MilightAction.off
                executeCommand(mode: .rgbwwcw, action: action, zone: zone)
                
            case CharacteristicType.brightness:
                
                let brightness = characteristic.value as! Int
                executeCommand(mode: .rgbwwcw, action: .brightNess,value: brightness, zone: zone)
                
            case CharacteristicType.saturation:
                
                let saturation = characteristic.value as! Float
                if (saturation > 0){
                    executeCommand(mode: .rgbwwcw, action: .hue, value: saturation, zone: zone)
                }else{
                    Debugger.shared.log(debugLevel:.Native(logType:.info), "Switching to dedicated whitemode a.k.a cold white)")
                    executeCommand(mode: .rgbwwcw, action: .temperature, value:100,  zone: zone)
                }
                
            default:
                Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(accessoryName)")
            }
        }
    }
}
