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
import SoftPLC

@available(OSX 11.0, *)
extension CharacteristicType{
    
    var parameterName:PLCclass.HomekitParameterName{
        
        switch self{
        case CharacteristicType.powerState:
            return .powerState
        case CharacteristicType.brightness:
            return .brightness
        case CharacteristicType.targetPosition:
            return .setPoint
        default:
            Debugger.shared.log(debugLevel: .Warning, "No parameter name found for type \(self)")
            return .unKnown
        }
        
    }
    
}

@available(OSX 11.0, *)
extension SoftPLC:AccessoryDelegate{
    
    func handleCharacteristicChange<T>(
        
        _ accessory: Accessory,
        _ service: Service,
        _ characteristic: GenericCharacteristic<T>,
        _ value:T?
    ){
        let accessoryName = accessory.info.name.value!
        if var circuit = plcObjects[accessoryName] as? HomekitControllable{
            circuit.homekitParameters[characteristic.type.parameterName] = value
        }else{
            Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(accessoryName)")
        }
        
    }
    
}

