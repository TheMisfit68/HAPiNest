//
//  PLCAccessory.swift
//  HAPiNest
//
//  Created by Jan Verrept on 03/01/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import SoftPLC




class PLCAccessory:HAP.Accessory{
    
    let testAccessory:HAP.Accessory.Lightbulb = Accessory.Lightbulb(info: Service.Info(name: "Badkamer Licht", serialNumber: "00400"))
    
    let livingRoomLightbulb = Accessory.Lightbulb(info: Service.Info(name: "Living Room", serialNumber: "00002"))
    
    func test(){
        livingRoomLightbulb.lightbulb.powerState.value = true
    }
    
    public var plcObject:PLCclass
    
    
    
    init(){
        
    }
}
