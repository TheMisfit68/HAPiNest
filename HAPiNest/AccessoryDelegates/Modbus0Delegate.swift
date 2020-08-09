//
//  Modbus0Delegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 08/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import ModbusDriver

extension ModbusDriver{
    
    // Define additional addressing based on the accessoryname
    func handleModule0<T>(accessoryName:String, characteristic:GenericCharacteristic<T>){
        
        let module = self.ioModules.first
        let minBrightnessWhileOn:Float = 25.0
        
        switch accessoryName {
        case "Badkamer Sfeerlichtjes":
            
            let channelNumber = 0
            let outputSignal = module!.channels[channelNumber] as! AnalogOutputSignal
            var brightness:Float = outputSignal.scaledValue

            if let newValue = characteristic.value as? Bool{
                brightness = newValue ? max(brightness, minBrightnessWhileOn) : 0
            }else if let newValue = characteristic.value as? Int{
                brightness = Float(newValue)
            }
            outputSignal.scaledValue = brightness
            
        case "Slaapkamer Licht":
            
            let channelNumber = 1
            let outputSignal = module!.channels[channelNumber] as! AnalogOutputSignal
            var brightness:Float = outputSignal.scaledValue

            if let newValue = characteristic.value as? Bool{
                brightness = newValue ? max(brightness, minBrightnessWhileOn) : 0
            }else if let newValue = characteristic.value as? Int{
                brightness = Float(newValue)
            }
            outputSignal.scaledValue = brightness
            
        default:
            JVDebugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
        }
        
        
    }
    
}
