//
//  Light.swift
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

extension Light:Parameterizable{
    
    public func assignInputParameters(){
        
        if let hkState  = homekitParameters[.powerState] as? Bool{
            self.output = hkState
        }
        
        if let ioSignal = plc.signal(ioSymbol:instanceName+" ingeschakeld") as? DigitalInputSignal{
            self.feedbackValue = ioSignal.logicalValue
        }
      
    }
    
    public func assignOutputParameters(){
        if let ioSignal = plc.signal(ioSymbol:instanceName) as? DigitalOutputSignal{
            
            ioSignal.logicalValue = outputAsPuls
            
        }
    }
    
}

public class Light:PLCclass, HomekitControllable, PulsOperatedCircuit{
    
    var homekitParameters:[HomekitParameterName:Any] = [:]
    var output:Bool = false
    var feedbackValue:Bool? = nil

    let pulsTimer = DigitalTimer(type: .pulsLimition, time: 0.25)
    var outputAsPuls:Bool{
        // Only toggle if the output and its feedback are not already in sync
        var puls = (self.output != (feedbackValue ?? false))
        return puls.timed(using: pulsTimer)
    }
        
}
