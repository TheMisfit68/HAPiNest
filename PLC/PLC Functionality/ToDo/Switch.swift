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
import JVCocoa

class Switch:PLCclass, Parameterizable{
    
    var inputSignal:DigitalInputSignal{
        plc.signal(ioSymbol:instanceName) as! DigitalInputSignal
    }
    
    public func assignInputParameters(){
        action = inputSignal.logicalValue
    }
    
    public func assignOutputParameters(){
        // Switches have no outputs associated with them!
    }
    
    var action:Bool = false{
        didSet{
            if action != oldValue{
                // Perform some action
            }
        }
    }

}
