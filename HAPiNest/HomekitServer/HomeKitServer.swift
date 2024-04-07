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
import JVSwift
import JVSwiftCore
import JVScripting
import OSLog
import SwiftUI
import LeafDriver

public class HomeKitServer:Singleton, Loggable{
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
	
	//    let gscNotifier = GSCNotifier()
	//    let sunnyPortalReporter = SunnyPortalReporter()
	
	private init(){
				
		self.name = MainConfiguration.HomeKitServer.ServerName
#if DEBUG
		AppController(name: "Console", location: .systemUtilities, terminal: TerminalDriver()).startIfInstalled()
		AppController(name: "Home", location: .systemApps, terminal: TerminalDriver()).startIfInstalled()
#endif
		HomeKitServer.logger.info("Initializing the server \(self.name, privacy: .public)...")
		
		
		// TODO: - reimplement SMAInverter
		//      let _ = SMAInverter.CreateInverters()
		
		
	}
	
	deinit{
	}
	
}
