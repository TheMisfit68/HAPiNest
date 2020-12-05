//
//  Outlet.swift
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

extension Outlet:Parameterizable{
    
    public func assignInputParameters(){
        
        if let hkState  = homekitParameters[.powerState] as? Bool{
            self.output = hkState
        }
        
    }
    
    public func assignOutputParameters(){
        
        if let ioSignal = plc.signal(ioSymbol:instanceName) as? DigitalOutputSignal{
            ioSignal.outputLogic = .inverse
            ioSignal.logicalValue = output
        }
    }
    
}

class Outlet:PLCclass, HomekitControllable{
    
    var output:Bool = false
    var homekitParameters:[HomekitParameterName:Any] = [:]
    
}
