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

extension GaragePort:Parameterizable{
    
    public func assignInputParameters(){
        
        if let hkState  = homekitParameters[.unKnown] as? Enums.TargetDoorState{
            self.toggle = (hkState == .open)
        }
        
    }
    
    public func assignOutputParameters(){
        
        if let ioSignal = plc.signal(ioSymbol:instanceName) as? DigitalOutputSignal{
            ioSignal.logicalValue = output.timed(using: pulsTimer)
        }
        
    }
    
}

class GaragePort:ImpulsRelais, HomekitControllable{
    
    var homekitParameters:[HomekitParameterName:Any] = [:]
    let pulsTimer = DigitalTimer(type: .exactPuls, time: 1.0)
    
}
