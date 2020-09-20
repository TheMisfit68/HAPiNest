////
////  Modbus4Delegate.swift
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
//    // Define channelnumber based on the accessoryname
//    func handleModule4<T>(accessory:Accessory, characteristic:GenericCharacteristic<T>){
//        let module = self.ioModules.first
//        
//        let accessoryName = accessory.info.name.value!
//        var channelNumber:Int?{
//            
//            switch accessoryName {
//            case "Badkamer Licht":
//                return 0
//            case "Badkamer Licht spiegel":
//                return 1
//            case "Kelder Licht":
//                return 2
//            case "Buiten Licht":
//                return 3
//            case "Garage Licht":
//                return 4
//            case "Garage Licht Werkbank":
//                return 5
//            case "Keuken Licht kast":
//                return 6
//            case "Keuken Licht":
//                return 7
//            case "Bureau Licht":
//                return 8
//            case "Eetkamer Licht":
//                return 9
//            case "Hal Licht":
//                return 10
//            case "W.C. Licht":
//                return 11
//            case "Overloop Licht":
//                return 12
//            case "Dressing Licht":
//                return 13
//            default:
//                JVDebugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
//                return nil
//            }
//            
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
//                outputSignal.outputType = .toggle(0.5)
//                outputSignal.logicalValue = poweredOn
//                
//            default:
//                JVDebugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(accessoryName)")
//            }
//        }
//        
//    }
//    
//}
