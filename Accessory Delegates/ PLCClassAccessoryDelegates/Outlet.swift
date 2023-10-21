//
//  Outlet.swift
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
class Outlet:PLCClassAccessoryDelegate{
	
	// Accessory binding
	typealias AccessorySubclass = Accessory.Outlet
	var characteristicChanged: Bool = false
	
	// MARK: - State
	public var powerState:Bool? = nil
	
	// Hardware feedback state
	private var hardwarePowerState:Bool?{
		didSet{
			hardwareFeedbackChanged.set( (hardwarePowerState != nil) && (oldValue != nil) &&  (hardwarePowerState != oldValue) )
		}
	}
	var hardwareFeedbackChanged:Bool = false
	
	// Intializer that forces the outlets powerState On or Off at startup
	// (instead of using the existing hardwarePowerState as its starting point)
	public init(defaultPowerState:Bool){
		powerState = defaultPowerState
		super.init()
	}
	
	public override init(){
		powerState = nil
		super.init()
	}
	
	// MARK: - IO-Signal assignment
	var outputSignal:DigitalOutputSignal{
        return plc.signal(ioSymbol:.on(circuit:instanceName)) as! DigitalOutputSignal
	}
	
	// MARK: - Parameter assignment	
	public func assignInputParameters(){
		
		outputSignal.outputLogic = .inverse
		hardwarePowerState = outputSignal.logicalFeedbackValue

	}
	
	public func assignOutputParameters(){
		outputSignal.logicalValue = powerState ?? false
	}
	
	// MARK: - Processing
	public func runCycle() {
		 
		reevaluate(&powerState, characteristic:accessory.outlet.powerState, hardwareFeedback: hardwarePowerState)
		
		characteristicChanged.reset()
		hardwareFeedbackChanged.reset()

	}
	
}
