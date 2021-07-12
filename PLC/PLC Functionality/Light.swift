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

// MARK: - Accessory bindings
extension Light:AccessoryDelegate, AccessorySource{
	
	typealias AccessorySubclass = Accessory.Lightbulb

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
	
	public func writeCharacteristic<T>(_ characteristic:GenericCharacteristic<T>, to value: T?) {
		
		switch characteristic.type{
			case CharacteristicType.powerState:
				
				accessory.lightbulb.powerState.value = value as? Bool

			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
	}
	
}

// MARK: - PLC level class
public class Light:PLCclass, Parameterizable, Simulateable, PulsOperatedCircuit{

	// MARK: - State
	private var powerState:Bool? = nil
	
	// Accessory state
	var accessoryPowerState:Bool = false
	private var characteristicChanged:Bool = false
	
	// Hardware feedback state
	var hardwarePowerState:Bool?{
		didSet{
			hardwareFeedbackChanged = (hardwarePowerState != nil) && (oldValue != nil) &&  (hardwarePowerState != oldValue)
		}
	}
	private var hardwareFeedbackChanged:Bool = false

	// MARK: IO-Signal assignment
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
	
	// MARK: - Parameter assignment
	public func assignInputParameters(){
		
		hardwarePowerState = feedbackSignal?.logicalValue
		
		if (powerState == nil) && (hardwarePowerState != nil){
			powerState = hardwarePowerState
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
			writeCharacteristic(accessory.lightbulb.powerState, to: accessoryPowerstate)
		}
		
	}
	
	public func assignOutputParameters(){
		outputSignal.logicalValue = puls
	}
	
	// MARK: - Processing
	let pulsTimer = DigitalTimer.PulsLimition(time: 0.25)
	var puls:Bool{
		get{
			var puls = (powerState != nil) && (hardwarePowerState != nil) && (powerState != hardwarePowerState) // Only toggle if the powerState and its hardwarePowerState are not already in sync
			return puls.timed(using: pulsTimer)
		}
	}
	
	// MARK: - Hardware simulation
	// When in simulation mode,
	// provide the hardwareFeedback yourself
	private var teleruptor = ImpulsRelais()
	public func simulateHardwareInputs() {
		
		teleruptor.toggle = outputSignal.logicalValue
		feedbackSignal?.ioValue = teleruptor.output
		
	}
	
}
