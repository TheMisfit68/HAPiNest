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
            self.output = (hkState == .open)
        }
        
    }
    
    public func assignOutputParameters(){
        
        if let ioSignal = plc.signal(ioSymbol:instanceName) as? DigitalOutputSignal{
            ioSignal.logicalValue = outputAsPuls
        }
        
    }
    
}

class GaragePort:PLCclass, HomekitControllable, PulsOperatedCircuit{
    
    var homekitParameters:[HomekitParameterName:Any] = [:]
    var edgeDetection:EBool = EBool()
    var output:Bool = false

    let pulsTimer = DigitalTimer(type: .exactPuls, time: 1.0)
    var outputAsPuls:Bool{
        // Puls every time the door needs to be operated
        var puls = edgeDetection.anyEdge(onBoolean: output)
        return puls.timed(using: pulsTimer)
    }

    
}
