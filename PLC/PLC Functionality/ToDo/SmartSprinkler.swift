//
//  SmartSprinkler.swift
//  HAPiNest
//
//  Created by Jan Verrept on 17/01/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import Cocoa
import HAP
import SoftPLC
import ModbusDriver
import JVCocoa


public class SmartSprinkler:PLCclass, AccessoryDelegate, AccessorySource{
    
    // MARK: - HomeKit Accessory binding
    
    typealias AccessorySubclass = Accessory.SmartSprinkler
    
    private var characteristicChanged:Bool = false
    var hkAccessoryActive:Enums.Active = .inactive{
        didSet{
            // Only when circuit is idle
            // send the feedback upstream to the Homekit accessory,
            // provides for a more stable feedback
            if  !characteristicChanged && !feedbackChanged{
                accessory.irrigationSystem.active.value = active
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
        case CharacteristicType.active:
            
            hkAccessoryActive = characteristic.value as? Enums.Active ?? hkAccessoryActive
            
        default:
            Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
        }
    }
    
    // MARK: - PLC IO-Signal assignment

    var outputSignal:DigitalOutputSignal{
        plc.signal(ioSymbol:instanceName) as! DigitalOutputSignal
    }
    
    var feedbackSignal:DigitalOutputSignal?{
        outputSignal
    }
    
    // MARK: - PLC Parameter assignment
    
    public func assignInputParameters(){
        
        feedback = (feedbackSignal?.logicalValue ?? true) ? .active : .inactive
        
        if characteristicChanged{
            active = hkAccessoryActive
            
            characteristicChanged.reset()
        }else if feedbackChanged{
            active = feedback
        }
        
    }
    
    public func assignOutputParameters(){
        outputSignal.logicalValue = (active == .active)
        
        hkAccessoryActive = feedback
    }
    
    var feedback:Enums.Active = .active{
        didSet{
            feedbackChanged = (feedback != oldValue)
        }
    }
    private var feedbackChanged:Bool = false
    
    // MARK: - PLC Processing
    private var active:Enums.Active = .inactive

}
