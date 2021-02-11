//
//  GarageDoor.swift
//  HAPiNest
//
//  Created by Jan Verrept on 23/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Cocoa
import HAP
import SoftPLC
import ModbusDriver
import IOTypes
import JVCocoa

class GarageDoor:PLCclass, Parameterizable, AccessoryDelegate, AccessorySource, PulsOperatedCircuit{
    
    // MARK: - HomeKit Accessory binding

    typealias AccessorySubclass = Accessory.GarageDoorOpener.StatelessGarageDoorOpener

    private var characteristicChanged:Bool = false
    var hkAccessoryPowerState:Bool = false{
        didSet{
            // Only when circuit is idle
            // send the hardwareFeedback upstream to the Homekit accessory,
            // provides for a more stable hardwareFeedback
            if  !characteristicChanged{
                accessory.statelessGarageDoorOpener.powerState.value = hkAccessoryPowerState
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
    
    // MARK: - PLC Parameter assignment
    
    public func assignInputParameters(){
		
		if powerState == nil {
			powerState = false
		}else if characteristicChanged{
            powerState = hkAccessoryPowerState
        }
        
    }
    
    public func assignOutputParameters(){
        outputSignal.logicalValue = puls
        if !puls{
            powerState = false
        }
        
        hkAccessoryPowerState = powerState
        
        characteristicChanged.reset()
    }
        
    // MARK: - PLC Processing
    var powerState:Bool! = nil
        
    let pulsTimer = DigitalTimer.ExactPuls(time: 1.0)
    var puls:Bool{
        get{
			var puls:Bool = powerState
            return puls.timed(using: pulsTimer)
        }
    }

}


