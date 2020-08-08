//
//  HomeKitServer.swift
//  HomeKitServer
//
//  Created by Jan Verrept on 08/11/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import Darwin
import JVCocoa

import AppleScriptDriver
import SiriDriver
import MilightDriver
import ModbusDriver
import YASDIDriver
import TizenDriver
import LeafDriver

/**
 Homekitserver is a Singleton class that also acts
 as a container for all related driver-type classes
 that need to be globaly accessible
 */
public class HomeKitServer:Singleton{
    
    public static var shared: HomeKitServer = HomeKitServer()
    private var HAPserver:Server!
    var mainBridge:Bridge!{
        didSet{
            HAPserver = try? Server(device: self.mainBridge.device, listenPort: 8000)
            self.mainBridge.printPairingInstructions()
        }
    }
    
    let milightDriver = MilightDriverV6(ipAddress: "192.168.0.52")
    
    let siriDriver = SiriDriver(language: .flemish)
    
    let appleScripTDriver = AppleScriptDriver()
    
    let modBusDriver0 = ioLogicE1241(ipAddress: "192.168.0.150").modbusDriver
    let modBusDriver1 = ioLogicE1210(ipAddress: "192.168.0.151").modbusDriver
    let modBusDriver2 = ioLogicE1210(ipAddress: "192.168.0.152").modbusDriver
    let modBusDriver3 = ioLogicE1210(ipAddress: "127.0.0.1").modbusDriver
    let modBusDriver4 = ioLogicE1211(ipAddress: "192.168.0.154").modbusDriver
    let modBusDriver5 = ioLogicE1211(ipAddress: "127.0.0.1").modbusDriver
    let modBusDriver6 = ioLogicE1211(ipAddress: "192.168.0.156").modbusDriver
    
    let yasdiDriver = YASDIDriver.InstallDrivers().first
    let gscNotifier = GSCNotifier()
    let sunnyPortalReporter = SunnyPortalReporter()
    
    let tizenDriver1 = TizenDriver(tvName:"T.V. living", macAddress: "F8:3F:51:2E:C5:F1", ipAddress: "192.168.0.50", port: 8002, deviceName: "HAPiNestServer")
    let tizenDriver2 = TizenDriver(tvName:"T.V. slaapkamer", macAddress: "7C:64:56:80:4E:90", ipAddress: "192.168.0.140", port: 8002, deviceName: "HAPiNestServer")
    
    let leafDriver =  LeafDriver(leafProtocol: LeafProtocolV2())
    
    private init(){
        JVDebugger.shared.log(debugLevel: .Info, "Initializing the server...")
    }
    
}





