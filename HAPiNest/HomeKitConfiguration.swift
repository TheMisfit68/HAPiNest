//
//  HomeKitConfiguration.swift
//  HAPiNest
//
//  Created by Jan Verrept on 08/11/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Foundation
import HAP

// Global configInfo
let bridgeName = "NestBridge"
let bridgeSetupCode = "456-77-890"

let myAccessories:[Accessory]  = [
    
    // Lights
    Accessory.Lightbulb(info: Service.Info(name: "Balk", serialNumber: "00002"), type:.color, isDimmable: true),
    Accessory.Lightbulb(info: Service.Info(name: "UFO", serialNumber: "00003"), type:.color, isDimmable: true),
    Accessory.Lightbulb(info: Service.Info(name: "W.C.", serialNumber: "00004"), type:.color, isDimmable: true),
    
    Accessory.Lightbulb(info: Service.Info(name: "LampViaModbus)", serialNumber: "00005")),
    
    // Outlets
    Accessory.Outlet(info: Service.Info(name: "StopcontactViaModbus)", serialNumber: "00010")),

    
    // Heating
    
    // Solar Inverter
//    Accessory.PowerInverter(info: Service.Info(name: "Zonneënergie", serialNumber: "00029")),

    
    // Window coverings
    Accessory.WindowCovering(info: Service.Info(name: "Screen", serialNumber: "00050")),
    Accessory.WindowCovering(info: Service.Info(name: "Rolgrodijn", serialNumber: "00051")),
    
    // Multimedia
    Accessory.Television(info: Service.Info(name: "T.V.", serialNumber: "00060"), inputs: [("homeScreen", .homescreen)]),
    
    // Camera's
//   Accessory.
    
    //Sprinkler system
  
]

// Define below wich hardwaredrivers should be notified about events
protocol AccessoryDelegate{
    
      func handleCharacteristicChange<T>(
          
          _ accessory: Accessory,
          _ service: Service,
          _ characteristic: GenericCharacteristic<T>,
          _ value:T?
      )
    
}

let AccessoryDelegates:[String:AccessoryDelegate?] = [
    "Balk" : HomeKitServer.shared.milightDriver,
    "UFO" : HomeKitServer.shared.milightDriver,
    "W.C." : HomeKitServer.shared.milightDriver,
    "ModbusSimmulatedLight": HomeKitServer.shared.modBusDriver,
    "Zonneënergie": HomeKitServer.shared.yasdiDriver,
    "Screen": HomeKitServer.shared.modBusDriver,
    "Rolgrodijn": HomeKitServer.shared.modBusDriver
]
