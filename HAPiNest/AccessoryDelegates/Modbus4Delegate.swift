//
//  Modbus4Delegate.swift
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
    func handleModule4(accessoryName:String, characteristic:GenericCharacteristic<Bool>){
        
        let module = self.ioModules.first
        let newValue = characteristic.value!
        
        switch accessoryName {
        case "Badkamer Licht":
            
            let channelNumber = 0
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Badkamer Licht spiegel":
            
            let channelNumber = 1
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Kelder Licht":
            
            let channelNumber = 2
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Buiten Licht":
            
            let channelNumber = 3
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
        case "Garage Licht":
            
            let channelNumber = 4
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Garage Licht Werkbank":
            
            let channelNumber = 5
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Keuken Licht kast":
            
            let channelNumber = 6
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Keuken Licht":
            
            let channelNumber = 7
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Bureau Licht":
            
            let channelNumber = 8
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Eetkamer Licht":
            
            let channelNumber = 9
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Hal Licht":
            
            let channelNumber = 10
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "W.C. Licht":
            
            let channelNumber = 11
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Overloop Licht":
            
            let channelNumber = 12
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
        case "Dressing Licht":
            
            let channelNumber = 13
            let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
            outputSignal.outputType = .toggle(0.5)
            outputSignal.logicalValue = newValue
            
            
        default:
            JVDebugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
        }
        
        
    }
    
}
