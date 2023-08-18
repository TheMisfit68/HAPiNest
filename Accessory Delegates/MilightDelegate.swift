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
import OSLog

/// Handles characteristic changes for a Homekit Accessory.
/// It uses the MilightDriver to pass those changes to  the hardware

class MilightDelegate:AccessoryDelegate {
    
    let name:String
    let driver:MilightDriver
    let zone:MilightDriver.Zone
    
    var characteristicChanged: Bool = false
    
    var brightness:Int = 100{
        didSet{
            driver.executeCommand(mode: .rgbwwcw, action: .brightNess, value: brightness, zone: zone)
        }
    }
    var hue:Int = 0{
        didSet{
            if inWhiteMode{
                hue = 0
            }else{
                driver.executeCommand(mode: .rgbwwcw, action: .hue, value: hue, zone: zone)
            }
        }
    }
    var saturation:Int = 0{
        didSet{
            driver.executeCommand(mode: .rgbwwcw, action: .saturation, value: saturation, zone: zone)
            inWhiteMode = (saturation <= 16)
        }
    }
    var inWhiteMode:Bool = true{
        didSet{
            if inWhiteMode != oldValue{
                let currentBrightness = brightness
                if inWhiteMode{
                    let logger = Logger(subsystem: "be.oneclick.MilightDriver", category: "MilightDriverV6")
                    logger.info("Switching to dedicated whitemode")

                    hue = 0
                    saturation = 0
                    driver.executeCommand(mode: .rgbwwcw, action: .whiteOnlyMode,  zone: zone)
                    driver.executeCommand(mode: .rgbwwcw, action: .temperature, value:100,  zone: zone)
                }
                brightness = currentBrightness
            }
        }
    }
    
    
    public init(name:String,
                driver:MilightDriver,
                zone:MilightDriver.Zone
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
            let action = poweredOn ? MilightDriver.Action.on : MilightDriver.Action.off
            driver.executeCommand(mode: .rgbwwcw, action: action, zone: zone)
            
        case CharacteristicType.brightness:
            
            brightness = characteristic.value as! Int
            
        case CharacteristicType.hue:
            
            hue = Int(characteristic.value as! Float)
            
        case CharacteristicType.saturation:
            
            saturation = Int(characteristic.value as! Float)
            
        default:
            let logger = Logger(subsystem: "be.oneclick.HAPiNest", category: "MilightDelegate")
            logger.warning("Unhandled characteristic change for accessory \(self.name)")
        }
        
    }
    
    
}


