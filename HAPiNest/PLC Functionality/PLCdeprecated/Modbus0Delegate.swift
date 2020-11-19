////
////  Modbus0Delegate.swift
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
//    func handleModule0<T>(accessory:Accessory, characteristic:GenericCharacteristic<T>){
//        let module = self.ioModules.first
//        
//        let accessoryName = accessory.info.name.value!
//        var channelNumber:Int?{
//            
//            switch accessoryName {
//            case "Badkamer Sfeerlichtjes":
//                return 0
//            case "Slaapkamer Licht":
//                return 1
//            default:
//                Debugger.shared.log(debugLevel: .Warning, "Unknown accessory \(accessoryName)")
//                return nil
//            }
//            
//        }
//        
//        
//        
//    }
//    
//}
//
//
//
//
