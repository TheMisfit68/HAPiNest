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
import ModbusDriver

let milightDriver =  MilightDriverV6(ipAddress: "192.168.0.52")
let siriDriver = SiriDriver(language: .flemish)
let appleScripTDriver = AppleScriptDriver()
let modBusDriver = ModbusDriver(ipAddress: "127.0.0.1", port: 1502)

// Global configInfo
let myAccessories:[Accessory]  = [
    
    // Lights
    Accessory.Lightbulb(info: Service.Info(name: "Balk", serialNumber: "00002"), type:.color, isDimmable: true),
    Accessory.Lightbulb(info: Service.Info(name: "UFO", serialNumber: "00003"), type:.color, isDimmable: true),
    Accessory.Lightbulb(info: Service.Info(name: "W.C.", serialNumber: "00004"), type:.color, isDimmable: true),
    
    Accessory.Lightbulb(info: Service.Info(name: "ModbusSimmulatedLight", serialNumber: "00005")),
    
    // Outlets
    
    
    //Window coverings
    Accessory.WindowCovering(info: Service.Info(name: "Screen", serialNumber: "00050")),
    Accessory.WindowCovering(info: Service.Info(name: "Rolgrodijn", serialNumber: "00051")),
    
    //Multimedia
    Accessory.Television(info: Service.Info(name: "T.V.", serialNumber: "00060"), inputs: [("homeScreen", .homescreen)])
    
    //Camera's
    
]

protocol AccessoryDelegate{
    
      func handleCharacteristicChange<T>(
          
          _ accessory: Accessory,
          _ service: Service,
          _ characteristic: GenericCharacteristic<T>,
          _ value:T?
      )
    
}

let AccessoryDelegates:[String:AccessoryDelegate] = [
    "Balk" : milightDriver,
    "UFO" : milightDriver,
    "W.C." : milightDriver,
    "ModbusSimmulatedLight": modBusDriver
]
