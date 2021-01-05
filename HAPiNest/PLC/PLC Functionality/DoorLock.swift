//
//  DoorLock.swift
//  HAPiNest
//
//  Created by Jan Verrept on 23/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Cocoa
import HAP
import SoftPLC
import ModbusDriver
import JVCocoa

class Doorlock:PLCclass, HomekitControllable, PulsOperatedCircuit{
    
    var homeKitEvents:[CharacteristicType:Any] = [:]
    var homekitFeedbacks:[CharacteristicType:Any] = [:]

    var output:Bool = false
    
    let pulsTimer = DigitalTimer(type: .exactPuls, time: 2.0)
    var outputAsPuls:Bool{
        // Puls every time the door needs to open
        var puls = output
        return puls.timed(using: pulsTimer)
    }
    
    internal func parseNewHomeKitEvents(){
        
        if let hkState  = homeKitEvents[CharacteristicType.lockTargetState] as? Enums.LockTargetState{
            self.output = (hkState == .unsecured)
        }
        
        homeKitEvents = [:]
    }

    public func assignInputParameters(){
        
       parseNewHomeKitEvents()

    }
    
    public func assignOutputParameters(){
        
        if let ioSignal = plc.signal(ioSymbol:instanceName) as? DigitalOutputSignal{
            ioSignal.logicalValue = outputAsPuls
        }
        
    }

}
