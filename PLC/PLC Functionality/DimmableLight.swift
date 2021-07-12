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
import IOTypes
import JVCocoa

// MARK: - Accessory bindings
extension DimmableLight:AccessoryDelegate, AccessorySource{
	
	typealias AccessorySubclass = Accessory.Lightbulb
	
	func handleCharacteristicChange<T>(accessory:Accessory,
									   service: Service,
									   characteristic: GenericCharacteristic<T>,
									   to value: T?){
		
		// Handle Characteristic change depending on its type
		switch characteristic.type{
				
			case CharacteristicType.powerState:
				
				accessoryPowerState = value as? Bool ?? accessoryPowerState
				
			case CharacteristicType.brightness:
				
				accessoryBrightness = value as? Int ?? accessoryBrightness
				
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
		
		characteristicChanged.set()
	}
	
	public func writeCharacteristic<T>(_ characteristic:GenericCharacteristic<T>, to value: T?) {
		
		switch characteristic.type{
			case CharacteristicType.powerState:
				
				accessory.lightbulb.powerState.value = value as? Bool
				
			case CharacteristicType.brightness:
				
				accessory.lightbulb.brightness!.value = value as? Int
				
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
	}
	
}

// MARK: - PLC level class
public class DimmableLight:PLCclass, Parameterizable{
	
	// MARK: - State
	var powerState:Bool? = nil{
		didSet{
			if let powerState = powerState , powerState != oldValue{
				brightness = powerState ? previousbrightness : 0
			}
		}
	}
	
	var brightness:Int? = nil{
		didSet{
			if brightness != oldValue{
				// When swicthed on, remember each new brightnesslevel,
				// to be used as a startlevel later on
				if let brightness = brightness, brightness > switchOffLevelDimmer{
					previousbrightness = brightness
				}
			}
		}
	}
	private let switchOffLevelDimmer:Int = 15
	private var previousbrightness:Int = 15
	
	// Accessory state
	private var accessoryPowerState:Bool = false
	private var accessoryBrightness:Int = 100
	private var characteristicChanged:Bool = false
	
	// Hardware feedback state
	private var hardwareBrightness:Float?{
		didSet{
			hardwareFeedbackChanged = (hardwareBrightness != nil) && (oldValue != nil) &&  (hardwareBrightness != oldValue)
		}
	}
	private var hardwareFeedbackChanged:Bool = false
	
	// MARK: - PLC IO-Signal assignment
	
	var outputSignal:AnalogOutputSignal{
		plc.signal(ioSymbol:instanceName) as! AnalogOutputSignal
	}
	
	
	// MARK: - PLC Parameter assignment
	
	public func assignInputParameters(){
		
		
		hardwareBrightness = outputSignal.scaledFeedBackValue?.rounded()
		
		if (brightness == nil) && (hardwareBrightness != nil), let hardwareBrightness = hardwareBrightness{
			brightness = Int(value: hardwareBrightness)
			powerState = (brightness! >= switchOffLevelDimmer)
		}else if (brightness != nil) && characteristicChanged{
			powerState = accessoryPowerState
			brightness = accessoryBrightness
			characteristicChanged.reset()
		}else if (brightness != nil) && hardwareFeedbackChanged, let hardwareBrightness = hardwareBrightness{
			brightness = Int(value: hardwareBrightness)
			hardwareFeedbackChanged.reset()
		}else if let accessoryPowerstate = powerState, let accessoryBrightness = brightness{
			// Only write back to the Homekit accessory,
			// when the circuit is completely idle
			// (this garantees a more stable user experience)
			writeCharacteristic(accessory.lightbulb.powerState, to: accessoryPowerstate)
			writeCharacteristic(accessory.lightbulb.brightness!, to: accessoryBrightness)
		}
		
	}
	
	public func assignOutputParameters(){
		outputSignal.scaledValue = Float(brightness ?? 100)
	}
	
}

