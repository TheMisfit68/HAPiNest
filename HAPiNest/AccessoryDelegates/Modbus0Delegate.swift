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
    func handleModule0(accessoryName:String, characteristic:GenericCharacteristic<Float>){
        
        let module = self.ioModules.first
        let value = characteristic.value!
         
        switch accessoryName {
        case "Badkamer Sfeerlichtjes":
            
            let channelNumber = 0
            let outputSignal = module!.channels[channelNumber] as! AnalogOutputSignal
            outputSignal.logicalValue = value
            
        case "Slaapkamer Licht":
            
                let channelNumber = 1
                let outputSignal = module!.channels[channelNumber] as! AnalogOutputSignal
                outputSignal.logicalValue = value
            
        default:
            JVDebugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
        }
        
        
    }
    
}
