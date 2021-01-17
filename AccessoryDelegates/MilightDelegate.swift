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

class MilightDelegate:AccessoryDelegate {
    
    let name:String
    let driver:MilightDriver
    let zone:MilightZone
    
    public init(name:String,
                driver:MilightDriver,
                zone:MilightZone
    ) {
        self.name = name
        self.driver = driver
        self.zone = zone
    }
    
    func handleCharacteristicChange<T>(accessory:Accessory,
                                       service: Service,
                                       characteristic: GenericCharacteristic<T>,
                                       to value: T?){
        
        // Handle Characteristic change depending on its type
        switch characteristic.type{
        case CharacteristicType.powerState:
            
            let poweredOn = characteristic.value as! Bool
            let action = poweredOn ? MilightAction.on : MilightAction.off
            driver.executeCommand(mode: .rgbwwcw, action: action, zone: zone)
            
        case CharacteristicType.brightness:
            
            let brightness = characteristic.value as! Int
            driver.executeCommand(mode: .rgbwwcw, action: .brightNess,value: brightness, zone: zone)
            
        case CharacteristicType.saturation:
            
            let saturation = characteristic.value as! Float
            if (saturation > 0){
                driver.executeCommand(mode: .rgbwwcw, action: .hue, value: saturation, zone: zone)
            }else{
                Debugger.shared.log(debugLevel:.Native(logType:.info), "Switching to dedicated whitemode a.k.a cold white)")
                driver.executeCommand(mode: .rgbwwcw, action: .temperature, value:100,  zone: zone)
            }
            
        default:
            Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
        }
        
    }
    
}


