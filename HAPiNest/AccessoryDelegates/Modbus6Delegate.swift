//
//  Modbus6Delegate.swift
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
    func handleModule6<T>(accessoryName:String, characteristic:GenericCharacteristic<T>){
        
        let module = self.ioModules.first
        if let newValue = characteristic.value as? Bool{
            
            switch accessoryName {
            case "Kelder Compressor":
                
                let channelNumber = 0
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Buiten Stopcontact":
                
                let channelNumber = 1
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Garage Droogkast":
                
                let channelNumber = 2
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Garage Ventilatie":
                
                let channelNumber = 3
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Keuken Powerport":
                
                let channelNumber = 4
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Living Stopcontact barkast":
                
                let channelNumber = 5
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Living Stopcontact trap":
                
                let channelNumber = 6
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Bureau Stopcontact whiteboard":
                
                let channelNumber = 7
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Bureau Stopcontact":
                
                let channelNumber = 8
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Hal Stopcontact":
                
                let channelNumber = 9
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Slaapkamer Stopcontact bed rechts":
                
                let channelNumber = 10
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Slaapkamer Stopcontact Bed links":
                
                let channelNumber = 11
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Slaapkamer Stopcontact T.V.":
                
                let channelNumber = 12
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            case "Overloop Stopcontact":
                
                let channelNumber = 13
                let outputSignal = module!.channels[channelNumber] as! DigitalOutputSignal
                outputSignal.outputType = .level
                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
                outputSignal.logicalValue = newValue
                
            default:
                JVDebugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
            }
        }
    }
}
