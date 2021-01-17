//
//  TizenDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 03/03/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import TizenDriver

class TizenDelegate:AccessoryDelegate {

    let name:String
    let driver:TizenDriver
    
    public init(name: String,
                driver:TizenDriver
    ) {
        self.name = name
        self.driver = driver
    }
    
    func handleCharacteristicChange<T>(accessory:Accessory,
                                       service: Service,
                                       characteristic: GenericCharacteristic<T>,
                                       to value: T?){
        
        // Handle Characteristic change depending on its type
        switch characteristic.type{
        case CharacteristicType.active:
            
            let status = value as! Enums.Active
            switch status{
            case .active:
                driver.powerState = .poweringUp
            case .inactive:
                driver.powerState = .poweringDown
            }
            
            
        case CharacteristicType.activeIdentifier:
            
            // Use 'InputSource'-selector to switch channels instead
            let channelNumber = value as! UInt32
            switch channelNumber {
            //            case 11:
            //                // NetFlix
            //                let appCommand = TizenCommand(rawValue:"KEY_HDMI")!
            //
            //
            //            case 12:
            //                // YouTube
            //                let appCommand = TizenCommand(rawValue:"KEY_HDMI")!
            
            default:
                if let keyCommand = TizenCommand(rawValue:"KEY_\(channelNumber)"){
                    
                    let hdmiSourceCommand = TizenCommand(rawValue:"KEY_HDMI")!
                    driver.queue(commands:[hdmiSourceCommand, keyCommand])
                }
            }
            
        default:
            Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
            
        }
        
    }
}
    


