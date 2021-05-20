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
import IOTypes
import JVCocoa

public class Outlet:PLCclass, Parameterizable, AccessoryDelegate, AccessorySource{
	
	// Intializer that forces the outlets powerState On or Off at startup
	// (instead of using the existing hardwareFeedback as its starting point)
	public init(defaultPowerState:Bool){
		powerState = defaultPowerState
		super.init()
	}
	
	public override init(){
		powerState = nil
		super.init()
	}
    
    // MARK: - HomeKit Accessory binding
    
    typealias AccessorySubclass = Accessory.Outlet
    
    private var characteristicChanged:Bool = false
    var hkAccessoryPowerState:Bool = true{
        didSet{
            // Only when circuit is idle
            // send the feedback upstream to the Homekit accessory,
			// provides a more stable experience
			if  !characteristicChanged && !hardwareFeedbackChanged{
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
    
    // MARK: - PLC Parameter assignment
    
    public func assignInputParameters(){
        		
		hardwareFeedback = outputSignal.logicalFeedbackValue

		if (powerState == nil) && hardwareFeedbackChanged{
			powerState = outputSignal.logicalValue
		}else if (powerState != nil) && characteristicChanged{
            powerState = hkAccessoryPowerState
        }
        
    }
    
    public func assignOutputParameters(){
		
        outputSignal.outputLogic = .inverse
        outputSignal.logicalValue = powerState ?? false

		hkAccessoryPowerState = powerState ?? false
        characteristicChanged.reset()
    }
	        
	var hardwareFeedback:Bool?{
		didSet{
			hardwareFeedbackChanged = (hardwareFeedback != oldValue) && (hardwareFeedback != nil)
		}
	}
	private var hardwareFeedbackChanged:Bool = false
	
    // MARK: - PLC Processing
    private var powerState:Bool? = nil

}
