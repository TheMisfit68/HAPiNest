//
//  LeafAccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 30/01/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVSwift
import LeafDriver
import OSLog

class LeafAccessoryDelegate:LeafDriver, AccessoryDelegate, AccessorySource{
    
    var name: String{
        return String(localized:"Electric Car")
    }
    
    typealias AccessorySubclass = Accessory.ElectricCar
    
    var characteristicChanged: Bool = false
    
    let lowChargeLimit = 15
    
    var getBatteryStatusTimer:Timer!
    
    public override init(leafProtocol: LeafProtocol) {
        
        super.init(leafProtocol: leafProtocol)

        getBatteryStatusTimer = Timer.scheduledTimer(withTimeInterval: 1800, repeats: true) { timer in super.batteryChecker.getNewBatteryStatus()}
        getBatteryStatusTimer.tolerance = getBatteryStatusTimer.timeInterval/10.0 // Give the processor some slack with a 10% tolerance on the timeInterval
        
    }
    
    var startCharging:Bool = false{
        didSet{
            if startCharging{
                self.charger.startCharging()
            }
        }
    }
    
    var setAirco:Bool = false{
        didSet{
            if setAirco{
                self.acController.setAirCo(to: .on)
            }else{
                self.acController.setAirCo(to: .off)

            }
        }
    }
    
    func handleCharacteristicChange<T>(accessory: AccessorySubclass, service: Service, characteristic: GenericCharacteristic<T>, to value: T?) where T : CharacteristicValueType {
        let logger = Logger(subsystem: "be.oneclick.HAPiNest", category: "LeafAccessoryDelegate")
        
        switch service {
        case accessory.chargerService:
            
            switch characteristic.type{
            case CharacteristicType.powerState:
                
                startCharging = characteristic.value as! Bool
                
            default:
                logger.warning( "Unhandled characteristic change for accessory \(accessory.info.name.value ?? "")")
            }
            
//        case accessory.aircoService:
//            
//            switch characteristic.type{
//            case CharacteristicType.powerState:
//                
//                setAirco = characteristic.value as! Bool
//                
//            default:
//                logger.warning( "Unhandled characteristic change for accessory \(accessory.info.name.value ?? "")")
//            }
            
        default:
            logger.warning( "Unhandled characteristic change for accessory \(accessory.info.name.value ?? "")")
        }
        
        
        
    }
    
    var hardwareFeedbackChanged:Bool = false
    
    
    func pollCycle() {
        
        if let percentageRemaining = batteryChecker.percentageRemaining, let _ = batteryChecker.rangeRemaining{
            
            accessory.primaryService.batteryLevel?.value =  UInt8(percentageRemaining)
            if  (percentageRemaining >= lowChargeLimit){
                accessory.primaryService.statusLowBattery.value = .batteryNormal
            }else{
                accessory.primaryService.statusLowBattery.value = .batteryLow
            }
            
            
        }
        
        if let chargingState = batteryChecker.chargingState{
            accessory.primaryService.chargingState?.value = .charging
        }

    }
    
    private func sendSMS(phoneNumber:String, content:String){
        
    }
    
}

