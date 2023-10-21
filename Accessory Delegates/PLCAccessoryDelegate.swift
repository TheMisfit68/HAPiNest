//
//  PLCClassAccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 01/10/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import SoftPLC
import OSLog


class PLCAccessoryDelegate:AccessoryDelegate {
    
    var name: String = "SoftPLC"
    
    public var characteristicChanged:Bool = false
    
    func handleCharacteristicChange<T>(accessory:Accessory,
                                       service: Service,
                                       characteristic: GenericCharacteristic<T>,
                                       to value: T?){
        
        // Notify the PLC object (that has the same name) of the change
        // The object will process the change with each cycle
        if let plcObject = MainConfiguration.PLC.PLCobjects[accessory.name] as? any AccessoryDelegate{
            plcObject.characteristicChanged.set()
        }
          
    }
    
}
