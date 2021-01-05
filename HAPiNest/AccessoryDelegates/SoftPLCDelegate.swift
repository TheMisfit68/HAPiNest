//
//  SoftPLCDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 03/12/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import SoftPLC

extension SoftPLC:AccessoryDelegate{
    
    func handleCharacteristicChange<T>(
        
        _ accessory: Accessory,
        _ service: Service,
        _ characteristic: GenericCharacteristic<T>,
        _ value:T?
    ){
        let accessoryName = accessory.info.name.value!
        if let circuit = plcObjects[accessoryName] as? HomekitControllable{
            // Forward all events to the right PLC-object
            circuit.homeKitEvents[characteristic.type] = value
        }else{
            Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(accessoryName)")
        }
        
    }
    
}

