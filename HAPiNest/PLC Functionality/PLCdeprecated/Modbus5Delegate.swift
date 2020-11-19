////
////  Modbus5Delegate.swift
////  HAPiNest
////
////  Created by Jan Verrept on 08/08/2020.
////  Copyright © 2020 Jan Verrept. All rights reserved.
////
//import Foundation
//import HAP
//import JVCocoa
//import ModbusDriver
//
//extension ModbusDriver{
//    
//    // Define channelnumber based on the accessoryname
//    func handleModule5<T>(accessory:Accessory, characteristic:GenericCharacteristic<T>){
//        let module = self.ioModules.first
//        
//        let accessoryName = accessory.info.name.value!
//        var channelNumber:Int?{
//            
//            switch accessoryName {
//            case "Keuken Screens":
//                return 0
//            case "Living Screens":
//                return 1
//            case "Slaapkamer Screen":
//                return 2
//            case "Vide Screen":
//                return 3
//            case "Keuken Rolgordijnen":
//                return 4
//            case "Living Rolgordijnen":
//                return 5
//            case "Slaapkamer Rolgordijn":
//                return 6
//            case "Vide Rolgordijn":
//                return 7
//            case "Overloop Rolgordijn":
//                return 8
//            case "Garage Poort":
//                return 14
//            case "Voordeur":
//                return 15
//            default:
//                Debugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
//                return nil
//            }
//        }
//        
//        // Handle Characteristic change based on its type
//        if let module = module, let channelNumber = channelNumber{
//            
//            switch characteristic.type{
//            case CharacteristicType.targetPosition:
//                
//                let setPoint = characteristic.value as! uint8
//                let outputSignal = module.channels[channelNumber] as! DigitalOutputSignal
//                outputSignal.outputType = .toggle(0.5)
//            //                outputSignal.logicalValue = setPoint
//            
//            case CharacteristicType.currentPosition:
//                
//               print("The accessory \(accessoryName) actually moved somehow")
//            
//            default:
//                Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(accessoryName)")
//            }
//        }
//        
//    }
//}
//
