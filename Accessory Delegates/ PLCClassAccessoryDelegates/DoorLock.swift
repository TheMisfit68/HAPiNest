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

// MARK: - PLC level class
class Doorlock:PLCClassAccessoryDelegate, PulsOperatedCircuit{
	
	// Accessory binding
	typealias AccessorySubclass = Accessory.LockMechanism
	var characteristicChanged:Bool = false
	
	// MARK: - State
	var targetState:Enums.LockTargetState? = .secured
	var currentState:Enums.LockCurrentState? = nil
		
	// Hardware feedback state
	var hardwareCurrentState:Enums.LockCurrentState?{
		didSet{
			hardwareFeedbackChanged = (hardwareCurrentState != nil) && (oldValue != nil) &&  (hardwareCurrentState != oldValue)
		}
	}
	var hardwareFeedbackChanged:Bool = false
	
	// MARK: - PLC IO-Signal assignment
	var outputSignal:DigitalOutputSignal{
        return plc.signal(ioSymbol:.on(circuit:instanceName)) as! DigitalOutputSignal
	}
	
	// MARK: - PLC Parameter assignment	
	public func assignInputParameters(){
		hardwareCurrentState = outputSignal.logicalValue ? .unsecured : .secured
	}
	
	public func assignOutputParameters(){
		
		outputSignal.logicalValue = puls
		
	}
	
	// MARK: - PLC Processing
	public func runCycle(){
		
        
        // In the latest versions of the Home-App the targetstate should be kept in synch with the hardwareCurrentState
        // once the puls changed to false again
        reevaluate(&targetState, initialValue: (currentState ?? .secured == .unsecured ? .unsecured : .secured), characteristic:accessory.lockMechanism.lockTargetState, hardwareFeedback: (hardwareCurrentState ?? .secured == .unsecured ? .unsecured : .secured))

		reevaluate(&currentState, characteristic:accessory.lockMechanism.lockCurrentState, hardwareFeedback: hardwareCurrentState)
        
        characteristicChanged.reset()
		hardwareFeedbackChanged.reset()
		
	}
	
	let pulsTimer = DigitalTimer.ExactPuls(time: 2.0)
	var puls:Bool{
		get{
			var puls = (targetState == .unsecured) // Only toggle if targetState changed to .unsecured
			return puls.timed(using: pulsTimer)
		}
	}
	
}

