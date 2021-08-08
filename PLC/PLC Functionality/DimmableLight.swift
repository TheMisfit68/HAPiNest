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

// MARK: - PLC level class
public class DimmableLight:PLCClass, AccessoryDelegate, AccessorySource, Parameterizable, CyclicRunnable{
	
	// Accessory binding
	typealias AccessorySubclass = Accessory.Lightbulb
	var characteristicChanged: Bool = false
	
	// MARK: - State
	var powerState:Bool? = nil
	{
		didSet{
			if let powerState = powerState, powerState != oldValue {
				
				if powerState == true{
					brightness = previousbrightness
					// Don't process the 100% brightness that comes with every new on-state
					characteristicChanged.reset()
				}else{
					brightness = 0
				}
				
			}
		}
	}
	
	var brightness:Int? = nil{
		didSet{
			if brightness != oldValue{
				// When swicthed on, remember each new brightnesslevel,
				// (to be used as a startlevel later on)
				if let brightness = brightness, brightness > switchOffLevelDimmer{
					previousbrightness = brightness
				}
			}
		}
	}
	private let switchOffLevelDimmer:Int = 15
	private var previousbrightness:Int = 15
	
	// Hardware feedback state
	private var hardwareBrightness:Int?{
		didSet{
			hardwareFeedbackChanged = (hardwareBrightness != nil) && (oldValue != nil) &&  (hardwareBrightness != oldValue)
		}
	}
	var hardwareFeedbackChanged:Bool = false
	
	// MARK: - PLC IO-Signal assignment
	var outputSignal:AnalogOutputSignal{
		plc.signal(ioSymbol:instanceName) as! AnalogOutputSignal
	}
	
	// MARK: - PLC Parameter assignment
	public func assignInputParameters(){
		hardwareBrightness = Int(value: outputSignal.scaledFeedBackValue?.rounded() as Any)
	}
	
	public func assignOutputParameters(){
		outputSignal.scaledValue = Float(powerState == true ? (brightness ?? 0) : 0 )
	}
	
	// MARK: - Processing
	public func runCycle() {
		
		reevaluate(&powerState, initialValue: (hardwareBrightness ?? 0 > switchOffLevelDimmer),characteristic:accessory.lightbulb.powerState, hardwareFeedback: nil)
		reevaluate(&brightness, characteristic:accessory.lightbulb.brightness, hardwareFeedback:hardwareBrightness)
		
		characteristicChanged.reset()
		hardwareFeedbackChanged.reset()
		
	}
}


