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

public class Outlet:PLCclass, Parameterizable, AccessoryDelegate, AccessorySource{
    
    // MARK: - HomeKit Accessory binding
    
    typealias AccessorySubclass = Accessory.Outlet
    
    private var characteristicChanged:Bool = false
    var hkAccessoryPowerState:Bool = true{
        didSet{
            // Only when circuit is idle
            // send the feedback upstream to the Homekit accessory,
			// provides a more stable experience
            if  !characteristicChanged{
                accessory.outlet.powerState.value = hkAccessoryPowerState
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
    
    var feedbackSignal:DigitalOutputSignal?{
        outputSignal
    }
    
    // MARK: - PLC Parameter assignment
    
    public func assignInputParameters(){
            
		if powerState == nil {
			powerState = outputSignal.logicalValue
		}else if characteristicChanged{
            powerState = hkAccessoryPowerState
        }
        
    }
    
    public func assignOutputParameters(){
        outputSignal.outputLogic = .inverse
        outputSignal.logicalValue = powerState
        
		hkAccessoryPowerState = powerState
        characteristicChanged.reset()  
    }
        
    // MARK: - PLC Processing
    private var powerState:Bool! = nil

}
