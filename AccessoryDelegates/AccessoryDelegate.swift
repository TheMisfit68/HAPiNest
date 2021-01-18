//
//  AccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 29/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import SoftPLC


protocol AccessoryDelegate{
        
    var name:String{get}
    
    func handleCharacteristicChange<T>(accessory:Accessory,
                                       service: Service,
                                       characteristic: GenericCharacteristic<T>,
                                       to value: T?)
}

extension AccessoryDelegate where Self:PLCclass{
    
    var name:String{
        self.instanceName
    }
    
}

protocol AccessorySource:AccessoryDelegate{
    
    associatedtype AccessorySubclass
    var accessory:AccessorySubclass{get}
}

extension AccessorySource{
    
    var accessory:AccessorySubclass{
        HomeKitServer.shared.mainBridge.accessory(named: name) as! AccessorySubclass
    }
    
}


