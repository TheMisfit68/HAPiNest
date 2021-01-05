//
//  GaragePort.swift
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

class GaragePort:PLCclass, HomekitControllable, PulsOperatedCircuit{
    
    var homeKitEvents:[CharacteristicType:Any] = [:]
    var homekitFeedbacks:[CharacteristicType:Any] = [:]
    
    var edgeDetection:EdgeDetection = EBool()
    var output:Bool = false

    let pulsTimer = DigitalTimer(type: .exactPuls, time: 1.0)
    var outputAsPuls:Bool{
        // Puls every time the door needs to be operated
        var puls = edgeDetection.anyEdge(onBoolean: output)
        return puls.timed(using: pulsTimer)
    }
    
    
    internal func parseNewHomeKitEvents(){
        
        if let hkState  = homeKitEvents[CharacteristicType.targetDoorState] as? Enums.TargetDoorState{
            self.output = (hkState == .open)
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
