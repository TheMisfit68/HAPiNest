//
//  ModbusDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 03/12/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import ModbusDriver

extension ModbusDriver:AccessoryDelegate{
    
    func handleCharacteristicChange<T>(
        
        _ accessory: Accessory,
        _ service: Service,
        _ characteristic: GenericCharacteristic<T>,
        _ value:T?
    ){
        
        readAllInputs()

        if let accessoryName = accessory.info.name.value{
            if self === HomeKitServer.shared.modBusDriver0 {
                handleModule0(accessoryName: accessoryName, characteristic:characteristic)
            }else if self === HomeKitServer.shared.modBusDriver4 {
                handleModule4(accessoryName: accessoryName, characteristic:characteristic)
            }
            else if self === HomeKitServer.shared.modBusDriver5 {
                handleModule5(accessoryName: accessoryName, characteristic:characteristic)
            }
            else if self === HomeKitServer.shared.modBusDriver6 {
                handleModule6(accessoryName: accessoryName, characteristic:characteristic)
            }
        }
        
        writeAllOutputs()
        
    }
    
}
