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
import JVCocoa


/// A PLC-Class type object that is not an Accessory-Delegate
/// because it has no Accessory associated with it,
/// it only processes hardware-signals
class FunctionKey:PLCClassAccessoryDelegate{
	
	var characteristicChanged: Bool = false
	var hardwareFeedbackChanged: Bool = false
	

	private var inputPuls:Bool = false
	private var inputTriggered:EBool
	
	var clicked:Bool = false{
		didSet{
			if clicked{
#warning("DEBUGPRINT") // TODO: - remove temp print statement
				print("🐞\tClicked")
			}
			clicked.reset()
		}
	}
	
	let doubleclikInterval:TimeInterval
	let doubleClickTimer:DigitalTimer
	var doubleClicked:Bool = false{
		didSet{
			if doubleClicked{
#warning("DEBUGPRINT") // TODO: - remove temp print statement
				print("🐞\tDoubleClicked")
			}
			doubleClicked.reset()
		}
	}
	
	let longPressTime:TimeInterval
	let longPressTimer:DigitalTimer
	var longPressed:Bool = false{
		didSet{
			if longPressed{
#warning("DEBUGPRINT") // TODO: - remove temp print statement
				print("🐞\tPressedlong")
			}
			longPressed.reset()
		}
	}
	
	
		override init(){
		
		self.inputTriggered = EBool(&inputPuls)
				
		self.doubleclikInterval = 1.0
		self.doubleClickTimer = DigitalTimer.OffDelay(time: doubleclikInterval)
		
		self.longPressTime = 2.0
		self.longPressTimer = DigitalTimer.OnDelay(time: longPressTime)
		
		super.init()
	}
	
	var inputSignal:DigitalInputSignal{
		let ioSymbol:SoftPLC.IOSymbol = .functionKey(circuit:String(localized: "\(instanceName)", table:"AccessoryNames"))
		return plc.signal(ioSymbol:ioSymbol) as! DigitalInputSignal
	}
	
	public func assignInputParameters(){
		
		if let hardwarePuls = inputSignal.logicalValue{
			inputPuls = hardwarePuls
		}else{
			inputPuls = false
		}
		
	}
	
	public func assignOutputParameters(){
		// Function keys have no outputs associated with them!
	}
	
	// MARK: - PLC Processing
	public func runCycle() {
		
		let risingEdge = inputTriggered.🔼
		
		if  risingEdge && !doubleClickTimer.output{
			clicked.set()
		}else if risingEdge && doubleClickTimer.output{
			doubleClicked.set()
		}else if longPressTimer.output{
			longPressed.set()
		}
		
//		reevaluate(&clicked, characteristic:accessory.programmableSwitchEvent, hardwareFeedback: hardwarePowerState)
//		reevaluate(&doubleClicked, characteristic:accessory.outlet.powerState, hardwareFeedback: hardwarePowerState)

		
		
		doubleClickTimer.input = inputPuls
		longPressTimer.input = inputPuls
		
	}
	
}
