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

// MARK: - PLC level class
public class Light:PLCClass, AccessoryDelegate, AccessorySource, Parameterizable, CyclicRunnable, PulsOperatedCircuit, Simulateable{

	// Accessory binding
	typealias AccessorySubclass = Accessory.Lightbulb
	var characteristicChanged:Bool = false

	// MARK: - State
	public var powerState:Bool? = nil
	
	// Hardware feedback state
	private var hardwarePowerState:Bool?{
		didSet{
			hardwareFeedbackChanged.set( (hardwarePowerState != nil) && (oldValue != nil) &&  (hardwarePowerState != oldValue) )
		}
	}
	var hardwareFeedbackChanged:Bool = false

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
	}
	
	public func assignOutputParameters(){
		outputSignal.logicalValue = puls
	}
	
	// MARK: - Processing
	public func runCycle(){

		reevaluate(&powerState, characteristic:accessory.lightbulb.powerState, hardwareFeedback: hardwarePowerState)
		
		characteristicChanged.reset()
		hardwareFeedbackChanged.reset()
		
	}
	
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
