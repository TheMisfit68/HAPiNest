//
//  WindowCovering.swift
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

extension WindowCovering:Parameterizable{
    
    public func assignInputParameters(){
        
//        if let hksetpoint  = homekitParameters[.setPoint] as? Float{
//            self.setPoint = hksetpoint
//        }
//
//        if let ioSignal = plc.signal(ioSymbol:instanceName+" Op") as? DigitalInputSignal{
//            self.isOpening = ioSignal.logicalValue
//        }
//        if let ioSignal = plc.signal(ioSymbol:instanceName+" Neer") as? DigitalInputSignal{
//            self.isclosing = ioSignal.logicalValue
//        }
  
    }
    
    public func assignOutputParameters(){
        
        if let ioSignal = plc.signal(ioSymbol:instanceName) as? DigitalOutputSignal{
//            ioSignal.logicalValue = outputAsPuls
        }
        
    }
    
}


class WindowCovering:OpenCloseWithSetpoint, HomekitControllable{
    
    var homekitParameters:[HomekitParameterName:Any] = [:]
    
    let pulsTimer = DigitalTimer(type: .pulsLimition, time: 0.25)
//    var outputAsPuls:Bool{
//        // Only toggle if the outputs and their feedbacks are not already in sync
//        var puls = (self.outputOpen != (self.isOpening ?? false)) || (self.outputClose != (self.isclosing ?? false))
//        return puls.timed(using: pulsTimer)
//    }
    
}
