//
//  Switch.swift
//  HAPiNest
//
//  Created by Jan Verrept on 31/12/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation

import Cocoa
import HAP
import SoftPLC
import ModbusDriver
import IOTypes
import JVCocoa

#warning("TODO") // TODO: - Implement this class

class Switch:PLCClass, Parameterizable{
    
    var inputSignal:DigitalInputSignal{
        let ioSymbol:SoftPLC.IOSymbol = .on(circuit:String(localized: "\(instanceName)", table:"AccessoryNames"))
        return plc.signal(ioSymbol:ioSymbol) as! DigitalInputSignal
    }
    
    public func assignInputParameters(){
        action = inputSignal.logicalValue
    }
    
    public func assignOutputParameters(){
        // Switches have no outputs associated with them!
    }
    
    var action:Bool?{
        didSet{
            if action != oldValue{
                // Perform some action
            }
        }
    }

}
