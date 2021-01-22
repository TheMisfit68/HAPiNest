//
//  DoorLock.swift
//  HAPiNest
//
//  Created by Jan Verrept on 23/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Cocoa
import HAP
import SoftPLC
import ModbusDriver
import JVCocoa

class Doorlock:PLCclass, Parameterizable, AccessoryDelegate, AccessorySource, PulsOperatedCircuit{
    
    // MARK: - HomeKit Accessory binding
    
    typealias AccessorySubclass = Accessory.LockMechanism
    
    private var characteristicChanged:Bool = false
    var hkAccessoryLockTargetState:Enums.LockTargetState = .secured{
        didSet{
            // Only when circuit is idle
            // send the feedback upstream to the Homekit accessory,
			// provides a more stable experience
            if  !characteristicChanged{
                accessory.lockMechanism.lockTargetState.value = hkAccessoryLockTargetState
            }
        }
    }
    
    var hkAccessoryLockCurrentState:Enums.LockCurrentState = .secured{
        didSet{
            // Only when circuit is idle
            // send the feedback upstream to the Homekit accessory,
			// provides a more stable experience
            if  !characteristicChanged{
                accessory.lockMechanism.lockCurrentState.value = hkAccessoryLockCurrentState
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
        case CharacteristicType.lockTargetState:
            
            hkAccessoryLockTargetState = value as? Enums.LockTargetState ?? hkAccessoryLockTargetState

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
            
		if lockTargetState == nil {
			lockTargetState = .secured
		}else if characteristicChanged{
            lockTargetState = hkAccessoryLockTargetState
        }
        
    }
    
    public func assignOutputParameters(){
        
        outputSignal.logicalValue = puls
        if !puls{
            lockTargetState = .secured
        }
        
        hkAccessoryLockTargetState = lockTargetState
        hkAccessoryLockCurrentState = puls ? .unsecured : .secured
        
        characteristicChanged.reset()
    }
        
    // MARK: - PLC Processing
    var lockTargetState:Enums.LockTargetState! = nil
        
    let pulsTimer = DigitalTimer.ExactPuls(time: 2.0)
    var puls:Bool{
        get{
            var puls = (lockTargetState == .unsecured) // Only toggle if lockTargetState changed to .unsecured
            return puls.timed(using: pulsTimer)
        }
    }

}

