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
import YASDIDriver


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







