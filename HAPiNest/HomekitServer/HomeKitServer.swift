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
import OSLog

import AppleScriptDriver
import SiriDriver

public class HomeKitServer:Singleton{
    
    public static var shared: HomeKitServer = HomeKitServer()
	public var dashboard:HomeKitServerView?
	public var name:String
    private var HAPserver:Server!
    
	var mainBridge:Bridge!{
        didSet{
			let serverPort = MainConfiguration.HomeKit.ServerPort
			HAPserver = try? Server(device: mainBridge, listenPort: serverPort)
			dashboard = HomeKitServerView(qrCode: mainBridge.setupQRCode.asNSImage!)
        }
    }

    let siriDriver = SiriDriver(language: .flemish)
    let appleScriptDriver = AppleScriptDriver()
    
  
	//    let gscNotifier = GSCNotifier()
	//    let sunnyPortalReporter = SunnyPortalReporter()
    //    let sprinklerDriver = SmartSprinklerDriver()
    
    private init(){
		self.name = MainConfiguration.HomeKit.ServerName
		#if DEBUG
			AppController(name: "Home", location: .systemApps).startIfInstalled()
		#endif
        let logger = Logger(subsystem: "be.oneclick.HAPiNest", category: "HomeKitServer")
        logger.info("Initializing the server \(self.name, privacy: .public)...")

//      let _ = SMAInverter.CreateInverters()
        
    }
    
}
