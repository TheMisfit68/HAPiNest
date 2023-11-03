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
import SwiftUI
import SiriDriver
import LeafDriver

public class HomeKitServer:Singleton{
    
    public static var shared: HomeKitServer = HomeKitServer()
	public var dashboard:HomeKitServerView?
	public var name:String
    private var HAPserver:Server!

    
	var mainBridge:Bridge!{
        didSet{
			let serverPort = MainConfiguration.HomeKitServer.ServerPort
			HAPserver = try? Server(device: mainBridge, listenPort: serverPort)
            dashboard = HomeKitServerView(qrCode: Image(nsImage:mainBridge.setupQRCode.asNSImage!))
        }
    }

    let siriDriver = SiriDriver()
    
	//    let gscNotifier = GSCNotifier()
	//    let sunnyPortalReporter = SunnyPortalReporter()
    
    private init(){
        
		self.name = MainConfiguration.HomeKitServer.ServerName
		#if DEBUG
            AppController(name: "Console", location: .systemUtilities).startIfInstalled()
			AppController(name: "Home", location: .systemApps).startIfInstalled()
		#endif
        let logger = Logger(subsystem: "be.oneclick.HAPiNest", category: "HomeKitServer")
        logger.info("Initializing the server \(self.name, privacy: .public)...")

        
        #warning("TODO") // TODO: - reimplement SMAInverter
//      let _ = SMAInverter.CreateInverters()
        
    }
    
    deinit{
    }
    
}
