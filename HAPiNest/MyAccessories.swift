//
//  MyAccessories.swift
//  HAPiNest
//
//  Created by Jan Verrept on 08/11/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import AppleScriptDriver
import SiriDriver
import MilightDriver

// Global configInfo
let myAccessories:[Accessory]  = [
    
    // Lights
    Accessory.Lightbulb(info: Service.Info(name: "Balk", serialNumber: "00002"), type:.color, isDimmable: true),
    Accessory.Lightbulb(info: Service.Info(name: "UFO", serialNumber: "00003"), type:.color, isDimmable: true),
    Accessory.Lightbulb(info: Service.Info(name: "W.C.", serialNumber: "00004"), type:.color, isDimmable: true),
    
    // Outlets
    
    //Window coverings
    Accessory.WindowCovering(info: Service.Info(name: "Screen", serialNumber: "00050")),
    Accessory.WindowCovering(info: Service.Info(name: "Rolgrodijn", serialNumber: "00051")),
    
    //Multimedia
    Accessory.Television(info: Service.Info(name: "T.V.", serialNumber: "00060"), inputs: [("homeScreen", .homescreen)])
    
    
]


