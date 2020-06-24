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
    
    let mainBridgeDelegate = MainBridgeDelegate()
    public let configFile = FileStorage(filename: "configuration.json")
    private var HAPserver:Server!
    var bridge:Bridge!{
        didSet{
            self.bridge.delegate = mainBridgeDelegate
            HAPserver = try? Server(device: self.bridge, listenPort: 8000)
            self.bridge.printPairingInstructions()
        }
    }
    let milightDriver = MilightDriverV6(ipAddress: "192.168.0.52")
    
    let siriDriver = SiriDriver(language: .flemish)
    
    let appleScripTDriver = AppleScriptDriver()
    
    let modBusDriver = ModbusDriver(ipAddress: "127.0.0.1", port: 1502)
    
    let yasdiDriver = YASDIDriver.InstallDrivers().first
    let gscNotifier = GSCNotifier()
    let sunnyPortalReporter = SunnyPortalReporter()
        
    let tizenDriver1 = TizenDriver(tvName:"T.V. living", macAddress: "F8:3F:51:2E:C5:F1", ipAddress: "192.168.0.50", port: 8002, deviceName: "HAPiNestServer")
    let tizenDriver2 = TizenDriver(tvName:"T.V. slaapkamer", macAddress: "7C:64:56:80:4E:90", ipAddress: "192.168.0.140", port: 8002, deviceName: "HAPiNestServer")

    let leafDriver =  LeafDriver(leafProtocol: LeafProtocolV2())

    
    init(){
        JVDebugger.shared.log(debugLevel: .Info, "Initializing the server...")
        leafDriver.batteryChecker.getBatteryStatus()
        tizenDriver1.queue(commands: [.KEY_VOLUP, .KEY_VOLDOWN])
//        SMAInverter.CreateInverters()
    }
    
    func resetPairingInfo(){
        JVDebugger.shared.log(debugLevel: .Info, "Dropping all pairings, keys")
        try? configFile.write(Data())
    }
    
}







