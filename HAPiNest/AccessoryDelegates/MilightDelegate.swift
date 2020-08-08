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

extension MilightDriver:AccessoryDelegate{
    
    func handleCharacteristicChange<T>(
        
        _ accessory: Accessory,
        _ service: Service,
        _ characteristic: GenericCharacteristic<T>,
        _ value:T?
    ){
        
        if let accessoryName = accessory.info.name.value{
            
            // Define additional addressing based on the accessoryname
            var zone:MilightZone? = nil
            switch accessoryName {
            case "Balk":
                zone = MilightZone.zone01
            case "UFO":
                zone = MilightZone.zone02
            default:
                JVDebugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
            }
            
            if characteristic is HAP.GenericCharacteristic<Swift.Bool>{
                let action = (characteristic.value as! Bool) ? MilightAction.on : MilightAction.off
                executeCommand(mode: .rgbwwcw, action: action, zone: zone)
            }else if characteristic is HAP.GenericCharacteristic<Swift.Int>{
                let brightness = Int(characteristic.value as! Int)
                executeCommand(mode: .rgbwwcw, action: .brightNess,value: brightness, zone: zone)
            }else if characteristic is HAP.GenericCharacteristic<Swift.Float>{
                let degrees = Int(characteristic.value as! Float)
                if (degrees > 0){
                    executeCommand(mode: .rgbwwcw, action: .hue, value: degrees, zone: zone)
                }else{
                    JVDebugger.shared.log(debugLevel: .Info, "Switching to dedicated whitemode a.k.a cold white)")
                    executeCommand(mode: .rgbwwcw, action: .temperature, value:100,  zone: zone)
                }
            }
            
        }
    }
    
    
}
