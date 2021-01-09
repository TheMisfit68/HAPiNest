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

public class Outlet:PLCclass, HomekitControllable{
    
    // MARK: - HomeKit Acessory binding
    
    typealias AccessoryType = Accessory.Outlet
    
    var hkAccessoryState:Bool{
        get{
            connectedAccessory?.outlet.powerState.value ?? true
        }
        set{
            if enableHkfeedback{
                connectedAccessory?.outlet.powerState.value = newValue
            }
        }
    }
    
    var enableHkfeedback:Bool{
        // Only when circuit is idle
        // send the feedback upstream to the Homekit accessory
        // provides for a more stable feedback
        !hkStateChanged && !feedbackChanged
    }
    
    // MARK: - PLC IO-Signals
    
    var outputSignal:DigitalOutputSignal{
        plc.signal(ioSymbol:instanceName) as! DigitalOutputSignal
    }
    
    var feedbackSignal:DigitalOutputSignal?{
        outputSignal
    }
    
    // MARK: - PLC parameter assignment
    
    public func assignInputParameters(){
        
        hkState = hkAccessoryState
        feedback = feedbackSignal?.logicalValue ?? true
        
        if hkStateChanged{
            output = hkState
        }else if feedbackChanged{
            output = feedback
        }
    }
    
    public func assignOutputParameters(){
        outputSignal.outputLogic = .inverse
        outputSignal.logicalValue = output
        
        hkAccessoryState = feedback
    }
    
    
    var hkState:Bool = false{
        didSet{
            hkStateChanged = (hkState != oldValue)
        }
    }
    var feedback:Bool = false{
        didSet{
            feedbackChanged = (feedback != oldValue)
        }
    }
    private var hkStateChanged:Bool = false
    private var feedbackChanged:Bool = false
    
    private var output:Bool = false // Ensure outlet Deafult state to Off (SAFETY CONDITION)
}
