//
//  LeafAccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 30/01/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import LeafDriver
import OSLog

class LeafAccessoryDelegate:LeafDriver, AccessoryDelegate, AccessorySource{
    
    var name: String{
            return String(localized:"Electric Car")
    }
    
    typealias AccessorySubclass = Accessory.ElectricCar
    
    var characteristicChanged: Bool = false
    
    func handleCharacteristicChange<T>(accessory: AccessorySubclass, service: Service, characteristic: GenericCharacteristic<T>, to value: T?) where T : CharacteristicValueType {
        
        let test = accessory.aircoService
        let testSTring:String = accessory.info.name.value ?? ""
        switch characteristic.type{
        case CharacteristicType.powerState:
            //				self.batteryChecker.getBatteryStatus()
            if let percentageRemaining = batteryChecker.percentageRemaining, let rangeRemaining = batteryChecker.rangeRemaining{
                let textToSpeak = String(localized: "\(percentageRemaining) percent or \(rangeRemaining) kilometers remaining", bundle: .main)
                siriDriver.speak(text: textToSpeak)
            }
            break

        default:
            let logger = Logger(subsystem: "be.oneclick.HAPiNest", category: "LeafAccessoryDelegate")
            logger.warning( "Unhandled characteristic change for accessory \(accessory.info.name.value ?? "")")
        }
    }
    
    var hardwareFeedbackChanged:Bool = false
    
    
    func pollCycle() {

    }
    
}

