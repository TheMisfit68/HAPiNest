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
            self.start = (hkState == true)
            self.stop =  (hkState == false)
        }
        
        if let ioSignal = plc.signal(ioSymbol:instanceName+" ingeschakeld") as? DigitalInputSignal{
            self.feedbackValue = ioSignal.logicalValue
        }
      
    }
    
    public func assignOutputParameters(){
        if let ioSignal = plc.signal(ioSymbol:instanceName) as? DigitalOutputSignal{
            ioSignal.logicalValue = self.puls(for: 0.25)
        }
    }
    
}

public class Light:StartStop, HomekitControllable{
    
    var homekitParameters:[HomekitParameterName:Any] = [:]
    
    override init(){
        super.init()
    }
    
}
