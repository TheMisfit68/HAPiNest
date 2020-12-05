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
