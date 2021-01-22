//
//  DimmableLight.swift
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

public class DimmableLight:PLCclass, Parameterizable, AccessoryDelegate, AccessorySource{
	
	// MARK: - HomeKit Accessory binding
	
	typealias AccessorySubclass = Accessory.Lightbulb
	
	private var characteristicChanged:Bool = false
	
	var hkAccessoryPowerState:Bool = false{
		didSet{
			// Only when circuit is idle
			// send the feedback upstream to the Homekit accessory,
			// provides a more stable experience
			if  !characteristicChanged{
				accessory.lightbulb.powerState.value = hkAccessoryPowerState
			}
		}
	}
	var hkAccessoryBrightness:Int = 100{
		didSet{
			// Only when circuit is idle
			// send the feedback upstream to the Homekit accessory,
			// provides a more stable experience
			if  !characteristicChanged{
				accessory.lightbulb.brightness?.value = hkAccessoryBrightness
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
				
			case CharacteristicType.brightness:
				
				hkAccessoryBrightness = value as? Int ?? hkAccessoryBrightness
				
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
	}
	
	
	// MARK: - PLC IO-Signal assignment
	
	var outputSignal:AnalogOutputSignal{
		plc.signal(ioSymbol:instanceName) as! AnalogOutputSignal
	}
	
	
	// MARK: - PLC Parameter assignment
	
	public func assignInputParameters(){
		
		if brightness == nil {
			brightness = Int(outputSignal.scaledValue)
			powerState = (brightness >= switchOffLevelDimmer)
		}else if characteristicChanged{
			
			if powerState != hkAccessoryPowerState{
				powerState = hkAccessoryPowerState
			}else{
				brightness = hkAccessoryBrightness
			}
		}
		
	}
	
	public func assignOutputParameters(){
		outputSignal.scaledValue = Float(brightness)
		
		hkAccessoryPowerState = powerState
		hkAccessoryBrightness = brightness
		characteristicChanged.reset()
	}
	
	
	// MARK: - PLC Processing
	
	private let switchOffLevelDimmer:Int = 15
	private var previousbrightness:Int = 15
	
	var powerState:Bool = false{
		didSet{
			if powerState != oldValue{
				brightness = powerState ? previousbrightness : 0
			}
		}
	}
	
	var brightness:Int! = nil{
		didSet{
			if brightness != oldValue{
				// When swicthed on, remember each new brightnesslevel,
				// to be used as a startlevel later on
				if brightness > switchOffLevelDimmer{
					previousbrightness = brightness
				}
			}
		}
	}
	
	
}

