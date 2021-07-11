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
import IOTypes
import JVCocoa

// MARK: - Accessory bindings
extension Doorlock:AccessoryDelegate, AccessorySource{
	
	typealias AccessorySubclass = Accessory.LockMechanism

	func handleCharacteristicChange<T>(accessory:Accessory,
									   service: Service,
									   characteristic: GenericCharacteristic<T>,
									   to value: T?){
				
		// Handle Characteristic change depending on its type
		switch characteristic.type{
			case CharacteristicType.lockTargetState:
				
				accessoryTargetState = value as? Enums.LockTargetState ?? accessoryTargetState
				
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
		
		characteristicChanged.set()
	}
	
	public func writeCharacteristic<T>(_ characteristic:GenericCharacteristic<T>, to value: T?) {
		
		switch characteristic.type{
			case CharacteristicType.lockTargetState:
				
				accessory.lockMechanism.lockTargetState.value = value as? Enums.LockTargetState

			case CharacteristicType.lockCurrentState:
				
				accessory.lockMechanism.lockCurrentState.value = value as? Enums.LockCurrentState

			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
	}
	
}

// MARK: - PLC level class
class Doorlock:PLCclass, Parameterizable, PulsOperatedCircuit{
	
	// MARK: - State
	var targetState:Enums.LockTargetState = .secured
	var currentState:Enums.LockCurrentState? = nil
	
	// Accessory state
	var accessoryTargetState:Enums.LockTargetState = .secured
	var accessoryCurrentState:Enums.LockCurrentState = .secured
	private var characteristicChanged:Bool = false
	
	// Hardware feedback state
	var hardwareCurrentState:Enums.LockCurrentState?{
		didSet{
			hardwareFeedbackChanged = (hardwareCurrentState != nil) && (oldValue != nil) &&  (hardwareCurrentState != oldValue)
		}
	}
	private var hardwareFeedbackChanged:Bool = false
	
	
	// MARK: - PLC IO-Signal assignment
	var outputSignal:DigitalOutputSignal{
		plc.signal(ioSymbol:instanceName) as! DigitalOutputSignal
	}
	
	// MARK: - PLC Parameter assignment
	
	public func assignInputParameters(){
		
		hardwareCurrentState = outputSignal.logicalValue ? .unsecured : .secured

		if (currentState == nil) && (hardwareCurrentState != nil){
			currentState = hardwareCurrentState
			targetState = (currentState! == .unsecured ? .unsecured : .secured)
		}else if (currentState != nil) && characteristicChanged{
			targetState = accessoryTargetState
			characteristicChanged.reset()
		}else if (currentState != nil) && hardwareFeedbackChanged{
			currentState = hardwareCurrentState
			hardwareFeedbackChanged.reset()
		}else if let accessoryFeedback = currentState {
			// Only write back to the Homekit accessory,
			// when the circuit is completely idle
			// (this garantees a more stable user experience)
			writeCharacteristic(accessory.lockMechanism.lockCurrentState, to: accessoryFeedback)
			writeCharacteristic(accessory.lockMechanism.lockTargetState, to: targetState)
		}
		
	}
	
	public func assignOutputParameters(){
		
		outputSignal.logicalValue = puls
		if !puls{
			targetState = .secured
		}
		
	}
	
	// MARK: - PLC Processing
	
	let pulsTimer = DigitalTimer.ExactPuls(time: 2.0)
	var puls:Bool{
		get{
			var puls = (targetState == .unsecured) // Only toggle if targetState changed to .unsecured
			return puls.timed(using: pulsTimer)
		}
	}
	
}

