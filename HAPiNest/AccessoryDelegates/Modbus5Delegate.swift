//
//  Modbus5Delegate.swift
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
    func handleModule5(accessoryName:String, characteristic:GenericCharacteristic<Bool>){
        
        let module = self.ioModules.first
        let newValue = characteristic.value!
        
        switch accessoryName {
        case "Keuken Screen":
            
            let channelNumber = 0
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Living Screen":
            
            let channelNumber = 1
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Slaapkamer Screen":
            
            let channelNumber = 2
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Vide Screen":
            
            let channelNumber = 3
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
        case "Keuken Rolgordijn":
            
            let channelNumber = 4
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Living Rolgordijn":
            
            let channelNumber = 5
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Slaapkamer Rolgordijn":
            
            let channelNumber = 6
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Vide Rolgordijn":
            
            let channelNumber = 7
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Overloop Rolgordijn":
            
            let channelNumber = 8
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Garage Poort":
            
            let channelNumber = 14
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Voordeur":
            
            let channelNumber = 15
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        default:
            JVDebugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
        }
    }

}
