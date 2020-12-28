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

extension Doorlock:Parameterizable{
    
    public func assignInputParameters(){
        
        if let hkState  = homekitParameters[.unKnown] as? Enums.LockTargetState{
            self.output = (hkState == .unsecured)
        }
        
    }
    
    public func assignOutputParameters(){
        
        if let ioSignal = plc.signal(ioSymbol:instanceName) as? DigitalOutputSignal{
            ioSignal.logicalValue = outputAsPuls
        }
        
    }
    
}

class Doorlock:PLCclass, HomekitControllable, PulsOperatedCircuit{
    
    var homekitParameters:[HomekitParameterName:Any] = [:]
    var output:Bool = false
    
    let pulsTimer = DigitalTimer(type: .exactPuls, time: 2.0)
    var outputAsPuls:Bool{
        // Puls every time the door needs to open
        var puls = output
        return puls.timed(using: pulsTimer)
    }

}
