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

public class Light:PLCclass, Parameterizable, AccessoryDelegate, AccessorySource, PulsOperatedCircuit{
    
    // MARK: - HomeKit Accessory binding
    
    typealias AccessorySubclass = Accessory.Lightbulb
    
    private var characteristicChanged:Bool = false
    var hkAccessoryPowerState:Bool = false{
        didSet{
            // Only when circuit is idle
            // send the feedback upstream to the Homekit accessory,
            // provides for a more stable feedback
            if  !characteristicChanged && !feedbackChanged && !puls {
                accessory.lightbulb.powerState.value = hkAccessoryPowerState
            }
        }
    }
    
    func handleCharacteristicChange<T>(accessory:Accessory,
                                       service: Service,
                                       characteristic: GenericCharacteristic<T>,
                                       to value: T?){
        
        characteristicChanged.set()
        
        // Handle Characteristic change depending on its type
        switch characteristic.type{
        case CharacteristicType.powerState:
            
            hkAccessoryPowerState = value as? Bool ?? hkAccessoryPowerState
            
        default:
            Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
        }
    }
    
    
    // MARK: - PLC IO-Signal assignment
    
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
        
        feedback = feedbackSignal?.logicalValue ?? false
        
        if characteristicChanged{
            powerState = hkAccessoryPowerState
            characteristicChanged.reset()
        }else if feedbackChanged{
            powerState = feedback
        }
        
    }
    
    public func assignOutputParameters(){
        outputSignal.logicalValue = puls
        hkAccessoryPowerState = feedback
    }
    
    var feedback:Bool = false{
        didSet{
            feedbackChanged = (feedback != oldValue)
        }
    }
    private var feedbackChanged:Bool = false
    
    // MARK: - PLC Processing
    private var powerState:Bool = false
    
    let pulsTimer = DigitalTimer.PulsLimition(time: 0.25)
    var puls:Bool{
        get{
            var puls = (powerState != feedback) // Only toggle if the powerState and its feedback are not already in sync
            return puls.timed(using: pulsTimer)
        }
    }
    
}
