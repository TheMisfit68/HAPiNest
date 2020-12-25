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
            let unlock:Bool = (hkState == .unsecured)
            self.output = edgeDetection.risingEdge(onBoolean: unlock)
        }
        
    }
    
    public func assignOutputParameters(){
        
        if let ioSignal = plc.signal(ioSymbol:instanceName) as? DigitalOutputSignal{
            ioSignal.logicalValue = output.timed(using: pulsTimer)
        }
        
    }
    
}

class Doorlock:StartStop, HomekitControllable{
    
    var homekitParameters:[HomekitParameterName:Any] = [:]
    let pulsTimer = DigitalTimer(type: .exactPuls, time: 2.0)

    private var edgeDetection:EBool = EBool()

    
}
