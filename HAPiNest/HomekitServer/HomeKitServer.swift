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
import os.log

import AppleScriptDriver
import SiriDriver

public class HomeKitServer:Singleton{
    
    public static var shared: HomeKitServer = HomeKitServer()
	public var name:String
    private var HAPserver:Server!
    
    var mainBridge:Bridge!{
        didSet{
			var serverPort = MainConfiguration.HomeKit.ServerPort
			#if DEBUG
			if HAPiNestApp.InDeveloperMode{
				serverPort = 8123
			}
			#endif
			HAPserver = try? Server(device: mainBridge, listenPort: serverPort)
        }
    }
    
    let siriDriver = SiriDriver(language: .flemish)
    let appleScripTDriver = AppleScriptDriver()
    
  
	//    let gscNotifier = GSCNotifier()
	//    let sunnyPortalReporter = SunnyPortalReporter()
    //    let sprinklerDriver = SmartSprinklerDriver()
    
    private init(){
		self.name = MainConfiguration.HomeKit.ServerName
		#if DEBUG
		if HAPiNestApp.InDeveloperMode{
			self.name = "Development\(self.name)"
			AppController(name: "Home", location: .systemApps).startIfInstalled()
		}
		#endif
        Debugger.shared.log(debugLevel: .Native(logType:.info), "Initializing the server \(self.name)...")
//      let _ = SMAInverter.CreateInverters()
        
    }
    
}



