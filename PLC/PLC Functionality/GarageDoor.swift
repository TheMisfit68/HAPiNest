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

// MARK: - PLC level class
class GarageDoor:PLCClass, AccessoryDelegate, AccessorySource, Parameterizable, CyclicRunnable, PulsOperatedCircuit{
	
	// Accessory binding
	typealias AccessorySubclass = Accessory.GarageDoorOpener.StatelessGarageDoorOpener
	var characteristicChanged: Bool = false
	
	// MARK: - State
	public var powerState:Bool? = nil
		
	// Hardware feedback state
	private var hardwarePowerState:Bool?{
		didSet{
			hardwareFeedbackChanged = (hardwarePowerState != nil) && (oldValue != nil) &&  (hardwarePowerState != oldValue)
		}
	}
	var hardwareFeedbackChanged:Bool = false
    
    // MARK: - PLC IO-Signal assignment
    var outputSignal:DigitalOutputSignal{
        plc.signal(ioSymbol:instanceName) as! DigitalOutputSignal
    }
    
    // MARK: - PLC Parameter assignment    
    public func assignInputParameters(){
		hardwarePowerState = outputSignal.logicalFeedbackValue
    }
    
    public func assignOutputParameters(){
		
        outputSignal.logicalValue = puls
		// TODO: - hardwrecuurnstate is evaluated constantly , remove after test
//        if !puls{
//            powerState = false
//        }
		
    }
	
    // MARK: - PLC Processing
	public func runCycle() {
		 
		reevaluate(&powerState, characteristic:accessory.statelessGarageDoorOpener.powerState, hardwareFeedback: hardwarePowerState)
		
		characteristicChanged.reset()
		hardwareFeedbackChanged.reset()
	}
	
    let pulsTimer = DigitalTimer.ExactPuls(time: 1.0)
    var puls:Bool{
        get{
			var puls:Bool = (powerState == true)
            return puls.timed(using: pulsTimer)
        }
    }

}


