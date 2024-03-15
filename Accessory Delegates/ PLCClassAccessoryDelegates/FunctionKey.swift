//
//  FunctionKey.swift
//  HAPiNest
//
//  Created by Jan Verrept on 31/12/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation

import Cocoa
import HAP
import SoftPLC
import ModbusDriver
import IOTypes
import JVSwift


class FunctionKey:PLCClassAccessoryDelegate{
	
	// MARK: - Accessory binding
	typealias AccessorySubclass = Accessory.StatelessProgrammableSwitch
	var characteristicChanged: Bool = false
	
	// MARK: - State
	private enum SwitchEvent:UInt8{
		case singlePress = 0
		case doublePress = 1
		case longPress = 2
	}
	
	private var clicksCounter:Int = 0
	private var switchEvent:SwitchEvent? = nil{
		
		didSet{
			clicksCounter = 0
			longPressTimer.reset()
			doubleClickTimer.reset()
		}
	}
	
	
	private var inputPuls:Bool = false
	private var inputTriggered:EBool
	
	private let doubleclikInterval:TimeInterval = 2.0
	private let doubleClickTimer:DigitalTimer
	
	private let longPressTime:TimeInterval = 3.0
	private let longPressTimer:DigitalTimer
	
	// Hardware feedback state
	// Function keys only have inputs, no controlable outputs and therefore also no associated hardwarefeedback
	var hardwareFeedbackChanged:Bool = false
	
	override init(){
		
		inputTriggered = EBool(&inputPuls)
		self.doubleClickTimer = DigitalTimer.OffDelay(time: doubleclikInterval)
		self.longPressTimer = DigitalTimer.OnDelay(time: longPressTime)
		
		super.init()
	}
	
	// MARK: - IO-Signal assignment
	var inputSignal:DigitalInputSignal{
		let ioSymbol:IOSymbol = .functionKey(circuit:String(localized: "\(instanceName)"))
		return plc.signal(ioSymbol:ioSymbol) as! DigitalInputSignal
	}
	
	// MARK: - PLC Parameter assignment
	public func assignInputParameters(){
		inputPuls = inputSignal.logicalValue ?? false
	}
	
	public func assignOutputParameters(){
		// Function keys have no outputs associated with them!
	}
	
	// MARK: - PLC Processing
	public func runCycle() {
		
		doubleClickTimer.input = inputPuls
		longPressTimer.input = inputPuls
		
		if longPressTimer.output{
			switchEvent = .longPress
		}else if (clicksCounter >= 2) {
			switchEvent = .doublePress
		}else if (clicksCounter == 1) && !doubleClickTimer.output{
			switchEvent = .singlePress
		}
		
		if inputTriggered.🔼 {
			clicksCounter += 1
		}else if !doubleClickTimer.output{
			clicksCounter = 0
		}
		
		reevaluate(&switchEvent, characteristic:accessory.primaryService.programmableSwitchEvent, hardwareFeedback: nil)
	}
	
}
