//
//  Outlet.swift
//  HAPiNest
//
//  Created by Jan Verrept on 14/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Cocoa
import HAP
import SoftPLC
import ModbusDriver
import JVCocoa

class Outlet:PLCclass, HomekitControllable{

    var homeKitEvents:[CharacteristicType:Any] = [:]
    var homekitFeedbacks:[CharacteristicType:Any] = [:]

    var output:Bool = true
    
    internal func parseNewHomeKitEvents(){
        
        if let hkState  = homeKitEvents[.powerState] as? Bool{
            self.output = hkState
        }
        
        homeKitEvents = [:]
    }
    
    public func assignInputParameters(){
        
        parseNewHomeKitEvents()
        
    }
    
    public func assignOutputParameters(){
        
        if let ioSignal = plc.signal(ioSymbol:instanceName) as? DigitalOutputSignal{
            ioSignal.outputLogic = .inverse
            ioSignal.logicalValue = output
        }
    }
    
}
