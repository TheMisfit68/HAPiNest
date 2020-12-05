////
////  Modbus6Delegate.swift
////  HAPiNest
////
////  Created by Jan Verrept on 08/08/2020.
////  Copyright © 2020 Jan Verrept. All rights reserved.
////
//
//import Foundation
//import HAP
//import JVCocoa
//import ModbusDriver
//
//extension ModbusDriver{
//    
//    // Define additional addressing based on the accessoryname
//    func handleModule6<T>(accessory:Accessory, characteristic:GenericCharacteristic<T>){
//        let module = self.ioModules.first
//        
//        let accessoryName = accessory.info.name.value!
//        var channelNumber:Int?{
//            switch accessoryName {
//            case "Kelder Compressor":
//                return 0
//            case "Buiten Stopcontact":
//                return 1
//            case "Garage Droogkast":
//                return 2
//            case "Garage Ventilatie":
//                return 3
//            case "Keuken Powerport":
//                return 4
//            case "Living Stopcontact barkast":
//                return 5
//            case "Living Stopcontact trap":
//                return 6
//            case "Bureau Stopcontact whiteboard":
//                return 7
//            case "Bureau Stopcontact":
//                return 8
//            case "Hal Stopcontact":
//                return 9
//            case "Slaapkamer Stopcontact bed rechts":
//                return 10
//            case "Slaapkamer Stopcontact Bed links":
//                return 11
//            case "Slaapkamer Stopcontact T.V.":
//                return 12
//            case "Overloop Stopcontact":
//                return 13
//            default:
//                Debugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
//                return nil
//            }
//        }
//        
//        // Handle Characteristic change depending on its type
//        if let module = module, let channelNumber = channelNumber{
//            
//            switch characteristic.type{
//            case CharacteristicType.powerState:
//                
//                let poweredOn = characteristic.value as! Bool
//                
//                let outputSignal = module.channels[channelNumber] as! DigitalOutputSignal
//                outputSignal.outputLogic = .inverse // Use inverse logic, due to the use of N.C.-contacts in the output-circuit!
//                outputSignal.logicalValue = poweredOn
//                
//            default:
//                Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(accessoryName)")
//            }
//        }
//        
//    }
//}
//
