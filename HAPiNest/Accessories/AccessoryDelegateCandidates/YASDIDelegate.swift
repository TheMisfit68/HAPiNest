//
//  YASDIDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 26/12/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

//import Foundation
//import HAP
//import JVCocoa
//import YASDIDriver
//
//extension YASDIDriver:AccessoryDelegate{
//    
//    func handleCharacteristicChange<T>(
//        
//        _ accessory: Accessory,
//        _ service: Service,
//        _ characteristic: GenericCharacteristic<T>,
//        _ value:T?
//    ){
//        
//        let accessoryName = accessory.info.name.value!
//            
//            switch characteristic.type{
//            case CharacteristicType.powerState:
//                    break //TODO: - Implment info request on YASDI driver for Solarpanels
//            default:
//                Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(accessoryName)")
//            }
//        }
//
//}
