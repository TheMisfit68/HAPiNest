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


public class HomeKitServer:Singleton{
    
    let mainBridgeDelegate = MainBridgeDelegate()
    
    public static var shared: HomeKitServer = HomeKitServer()
    var bridge:Bridge!{
        didSet{
            self.bridge.delegate = mainBridgeDelegate
                HAPserver = try? Server(device: self.bridge, listenPort: 8000)
            self.bridge.printPairingInstructions()
        }
    }
    
    public let configFile = FileStorage(filename: "configuration.json")
    private var HAPserver:Server!
    
    init(){
        print("Initializing the server...")
    }
    
    func resetPairingInfo(){
        JVDebugger.shared.log(debugLevel: .Info, "Dropping all pairings, keys")
        try? configFile.write(Data())
    }
    
}


//device.delegate = delegate

//
//// Stop server on interrupt.
//var keepRunning = true
//func stop() {
//    DispatchQueue.main.async {
//        JVDebugger.shared.log(debugLevel: .Info, "Shutting down...")
//        keepRunning = false
//    }
//}
//signal(SIGINT) { _ in stop() }
//signal(SIGTERM) { _ in stop() }
//
//
//withExtendedLifetime([delegate]) {
//    if CommandLine.arguments.contains("--test") {
//        print("Running runloop for 10 seconds...")
//        RunLoop.main.run(until: Date(timeIntervalSinceNow: 10))
//    } else {
//        while keepRunning {
//            RunLoop.current.run(mode: .default, before: Date.distantFuture)
//        }
//    }
//}
//
//try server.stop()
//JVDebugger.shared.log(debugLevel: .Info, "Stopped")






