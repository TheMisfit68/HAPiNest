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

// MARK: - Accessory bindings
extension GarageDoor:AccessoryDelegate, AccessorySource{
	
	typealias AccessorySubclass = Accessory.GarageDoorOpener.StatelessGarageDoorOpener
	
	func handleCharacteristicChange<T>(accessory:Accessory,
									   service: Service,
									   characteristic: GenericCharacteristic<T>,
									   to value: T?){
		
		// Handle Characteristic change depending on its type
		switch characteristic.type{
			case CharacteristicType.powerState:
				
				accessoryPowerState = value as? Bool ?? accessoryPowerState
				
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
		
		characteristicChanged.set()
	}
	
	func writeCharacteristic<T>(_ characteristic:GenericCharacteristic<T>, to value: T?) {
		
		switch characteristic.type{
			case CharacteristicType.powerState:
				
				accessory.statelessGarageDoorOpener.powerState.value = value as? Bool
				
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
	}
	
}

// MARK: - PLC level class
class GarageDoor:PLCclass, Parameterizable, PulsOperatedCircuit{
	
	// MARK: - State
	public var powerState:Bool? = nil
	
	// Accessory state
	private var accessoryPowerState:Bool = false
	private var characteristicChanged:Bool = false
	
	// Hardware feedback state
	private var hardwarePowerState:Bool?{
		didSet{
			hardwareFeedbackChanged = (hardwarePowerState != nil) && (oldValue != nil) &&  (hardwarePowerState != oldValue)
		}
	}
	private var hardwareFeedbackChanged:Bool = false
    
    // MARK: - PLC IO-Signal assignment

    var outputSignal:DigitalOutputSignal{
        plc.signal(ioSymbol:instanceName) as! DigitalOutputSignal
    }
    
    // MARK: - PLC Parameter assignment
    
    public func assignInputParameters(){
		
		hardwarePowerState = outputSignal.logicalFeedbackValue
		
		if (powerState == nil) && (hardwarePowerState != nil){
			powerState = false
		}else if (powerState != nil) && characteristicChanged{
			powerState = accessoryPowerState
			characteristicChanged.reset()
		}else if (powerState != nil) && hardwareFeedbackChanged{
			powerState = hardwarePowerState
			hardwareFeedbackChanged.reset()
		}else if let accessoryPowerstate = self.powerState{
			// Only write back to the Homekit accessory,
			// when the circuit is completely idle
			// (this garantees a more stable user experience)
			writeCharacteristic(accessory.statelessGarageDoorOpener.powerState, to: accessoryPowerstate)
		}
        
    }
    
    public func assignOutputParameters(){
		
        outputSignal.logicalValue = puls
        if !puls{
            powerState = false
        }
		
    }
	
    // MARK: - PLC Processing        
    let pulsTimer = DigitalTimer.ExactPuls(time: 1.0)
    var puls:Bool{
        get{
			var puls:Bool = (powerState == true)
            return puls.timed(using: pulsTimer)
        }
    }

}


