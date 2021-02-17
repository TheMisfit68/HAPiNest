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
import IOTypes
import JVCocoa

public class Light:PLCclass, Parameterizable, Simulateable, AccessoryDelegate, AccessorySource, PulsOperatedCircuit{
	
	// MARK: - HomeKit Accessory binding
	
	typealias AccessorySubclass = Accessory.Lightbulb
	
	private var characteristicChanged:Bool = false
	var hkAccessoryPowerState:Bool = false{
		didSet{
			// Only when circuit is idle
			// send the hardwareFeedback upstream to the Homekit accessory,
			// provides a more stable experience
			if  !characteristicChanged && !hardwareFeedbackChanged{
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
			nameFeedBackSignal = instanceName+" On"
		}
		return plc.signal(ioSymbol:nameFeedBackSignal) as? DigitalInputSignal
	}
	
	// MARK: - PLC parameter assignment
	
	public func assignInputParameters(){
		
		hardwareFeedback = feedbackSignal?.logicalValue
		
		if (powerState == nil) && (hardwareFeedback != nil) && hardwareFeedbackChanged{
			powerState = hardwareFeedback
		}else if characteristicChanged && (hkAccessoryPowerState != nil){
			powerState = hkAccessoryPowerState
		}else if (hardwareFeedback != nil) && (hardwareFeedback != nil){
			powerState = hardwareFeedback        }
		
	}
	
	public func assignOutputParameters(){
		outputSignal.logicalValue = puls
		
		hkAccessoryPowerState = powerState ?? false
		characteristicChanged.reset()
	}
	
	var hardwareFeedback:Bool?{
		didSet{
			hardwareFeedbackChanged = (hardwareFeedback != oldValue)
		}
	}
	private var hardwareFeedbackChanged:Bool = false
	
	// MARK: - PLC Processing
	private var powerState:Bool! = nil
	
	let pulsTimer = DigitalTimer.PulsLimition(time: 0.25)
	var puls:Bool{
		get{
			var puls = (powerState != nil) && (hardwareFeedback != nil) && (powerState != hardwareFeedback) // Only toggle if the powerState and its hardwareFeedback are not already in sync
			return puls.timed(using: pulsTimer)
		}
	}
	
	// MARK: - Simulation hardware
	
	// When in simulation mode,
	// provide the hardwarefeedback yourself
	private var teleruptor = ImpulsRelais()
	public func simulateHardwareFeedback() {
		
		teleruptor.toggle = outputSignal.logicalValue
		feedbackSignal?.logicalValue = teleruptor.output
		
	}
	
}
