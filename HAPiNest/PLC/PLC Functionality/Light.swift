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
        
            output = output && !(feedbackValue ?? false) // Reset if the output and its feedback are the same
            ioSignal.logicalValue = output.timed(using: pulsTimer)
            
        }
    }
    
}

public class Light:StartStop, HomekitControllable{
    
    var homekitParameters:[HomekitParameterName:Any] = [:]
    let pulsTimer = DigitalTimer(type: .pulsLimition, time: 0.25)
        
}
