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

public class Light:PLCclass, HomekitControllable, PulsOperatedCircuit{
    
    // MARK: - HomeKit Accessory binding
    
    typealias AccessoryType = Accessory.Lightbulb
    
    var hkAccessoryState:Bool{
        get{
            connectedAccessory?.lightbulb.powerState.value ?? false
        }
        set{
            if enableHkfeedback {
                connectedAccessory?.lightbulb.powerState.value = newValue
            }
        }
    }
    
    var enableHkfeedback:Bool{
        // Only when circuit is idle
        // send the feedback upstream to the Homekit accessory
        // provides for a more stable feedback
        !hkStateChanged && !feedbackChanged && !outputAsPuls
    }
    
    // MARK: - PLC IO-Signals
    
    var outputSignal:DigitalOutputSignal{
        plc.signal(ioSymbol:instanceName) as! DigitalOutputSignal
    }
    
    var feedbackSignal:DigitalInputSignal?{
        let nameFeedBackSignal:String
        if instanceName.contains("Enable"){
            nameFeedBackSignal = instanceName.replacingOccurrences(of: "Enable", with: "Enabled")
        }else{
            nameFeedBackSignal = instanceName+" Ingeschakeld"
        }
        return plc.signal(ioSymbol:nameFeedBackSignal) as? DigitalInputSignal
    }

    
    // MARK: - PLC parameter assignment
    
    public func assignInputParameters(){
        
        hkState = hkAccessoryState
        feedback = feedbackSignal?.logicalValue ?? false
        
        if hkStateChanged{
            output = hkState
        }else if feedbackChanged{
            output = feedback
        }
    }
    
    public func assignOutputParameters(){
        outputSignal.logicalValue = outputAsPuls
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
    
    private var output:Bool = false
    
    let pulsTimer = DigitalTimer(type: .pulsLimition, time: 0.25)
    var outputAsPuls:Bool{
        var puls = (output != feedback) // Only toggle if the output and its feedback are not already in sync
        return puls.timed(using: pulsTimer)
    }
    
}
