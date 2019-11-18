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

// JUST FOR TESTING PURPOSES!!
let testDriver =  MilightDriverV6(ipAddress: "192.168.0.52")
let testSiri = SiriDriver(language: .flemish)
let testScript = AppleScriptDriver()

// Global configInfo
let myAccessories:[Accessory]  = [
        
        // Lights
        Accessory.Lightbulb(info: Service.Info(name: "Balk", serialNumber: "00002")),
        Accessory.Lightbulb(info: Service.Info(name: "UFO", serialNumber: "00003")),
        Accessory.Lightbulb(info: Service.Info(name: "W.C.", serialNumber: "00004")),

        
        // Outlets
        Accessory.Outlet(info: Service.Info(name: "T.V.", serialNumber: "00005")),

]
