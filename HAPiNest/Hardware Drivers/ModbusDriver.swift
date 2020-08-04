//
//  ModbusDriver.swift
//  HAPiNest
//
//  Created by Jan Verrept on 03/12/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import ModbusDriver
import JVCocoa

extension ModbusDriver:AccessoryDelegate{
    
    func handleCharacteristicChange<T>(
        
        _ accessory: Accessory,
        _ service: Service,
        _ characteristic: GenericCharacteristic<T>,
        _ value:T?
    ){
        
        let digitalInputModule:ioLogicE1210 = ioLogicE1210(ipAddress:"127.0.0.1", port:1502)
        let digitalOutputModule:ioLogicE1211 = ioLogicE1211(ipAddress:"127.0.0.1", port:1502)
        digitalInputModule.modbusDriver.readAllInputs()
        
        if let accessoryName = accessory.info.name.value{
            // Define additional addressing based on the accessoryname
            
            switch accessoryName {
            case "ModbusSimmulatedLight":
                
                let module = digitalOutputModule
                let channelNumber = 0
                let value = characteristic.value as! Bool
                let outputSignal = module.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.value = value
                
            default:
                JVDebugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
            }
            
        }
        
        digitalOutputModule.modbusDriver.writeAllOutputs()
        
    }
    
}
