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
        //
        //        if let ioSignal = plc.signal(ioSymbol:instanceName+" Op") as? DigitalInputSignal{
        //            self.isOpening = ioSignal.logicalValue
        //        }
        //        if let ioSignal = plc.signal(ioSymbol:instanceName+" Neer") as? DigitalInputSignal{
        //            self.isclosing = ioSignal.logicalValue
        //        }
        //        self.setPoint = homekitParameters[.setPoint] as! Float
    }
    
    public func assignOutputParameters(){
        
        //        if let ioSignal = plc.signal(ioSymbol:instanceName) as? DigitalOutputSignal{
        //            ioSignal.logicalValue = self.outputOpen
        //        }
        //
        ////        if let ioSignal = plc.signal(ioSymbol:instanceName) as? DigitalOutputSignal{
        ////            ioSignal.logicalValue = self.outputClose
        ////        }
        //
    }
    
}

class WindowCovering:OpenCloseWithSetpoint, HomekitControllable{
    
    var homekitParameters:[HomekitParameterName:Any] = [:]
    
}
