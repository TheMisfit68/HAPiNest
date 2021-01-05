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

extension Switch:Parameterizable{
    
    public func assignInputParameters(){
        
    }
    
    public func assignOutputParameters(){
        // Switches have no outputs associated!
    }
    
}

class Switch:PLCclass{
    
    var input:Bool = false
    
}
