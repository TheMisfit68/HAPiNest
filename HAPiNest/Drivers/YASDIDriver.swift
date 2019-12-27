//
//  YASDIDriver.swift
//  HAPiNest
//
//  Created by Jan Verrept on 26/12/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import YASDIDriver

extension YASDIDriver:AccessoryDelegate{
    
    func handleCharacteristicChange<T>(
        
        _ accessory: Accessory,
        _ service: Service,
        _ characteristic: GenericCharacteristic<T>,
        _ value:T?
    ){
        print("Not handling Characteristic changes for \(String(describing: self)) yet!")
    }
}
