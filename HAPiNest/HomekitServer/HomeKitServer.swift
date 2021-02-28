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
    private var HAPserver:Server!
    
    var mainBridge:Bridge!{
        didSet{
			HAPserver = try? Server(device: mainBridge, listenPort: MainConfiguration.HomeKit.ServerPort)
        }
    }
    
    let siriDriver = SiriDriver(language: .flemish)
    let appleScripTDriver = AppleScriptDriver()
    
  
	//    let gscNotifier = GSCNotifier()
	//    let sunnyPortalReporter = SunnyPortalReporter()
    //    let sprinklerDriver = SmartSprinklerDriver()
    
    
    
    private init(){
        Debugger.shared.log(debugLevel: .Native(logType:.info), "Initializing the server...")
//        let _ = SMAInverter.CreateInverters()
        
    }
    
}



