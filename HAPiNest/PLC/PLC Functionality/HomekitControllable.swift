//
//  HomekitControllable.swift
//  HAPiNest
//
//  Created by Jan Verrept on 29/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import SoftPLC
import JVCocoa

protocol HomekitControllable:Parameterizable{
    associatedtype AccessoryType

    var connectedAccessory:AccessoryType? {get}
}


extension HomekitControllable{
    
    var connectedAccessory:AccessoryType? {
        HomeKitServer.shared.mainBridge.accessory(named: self.instanceName) as? Self.AccessoryType
    }
    
}
 
