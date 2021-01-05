//
//  AccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 04/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import HAP


protocol AccessoryDelegate{
        
      func handleCharacteristicChange<T>(
          
          _ accessory: Accessory,
          _ service: Service,
          _ characteristic: GenericCharacteristic<T>,
          _ value:T?
      )
        
}


// Ensure that a Characteristics Type can be used as a key by AccessoryDelegates
// (so a Characteristics value can passed around as a key-value pair)
extension CharacteristicType:Hashable{
    
    public func hash(into hasher: inout Hasher) {
        
        let hashValue:String // Actually an exact copy of the implementation of rawValue (which was defined internal in HAP)
        switch self {
        case let .appleDefined(value):
            hashValue = String(value, radix: 16)
        case let .custom(uuid):
            hashValue = uuid.uuidString
        }
        hasher.combine(hashValue)
    }
    
}

