//
//  WindowCovering.swift
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

class WindowCovering:PLCclass, Parameterizable, Simulateable, AccessoryDelegate, AccessorySource, PulsOperatedCircuit{
	
	init(secondsToOpen:Int = 15, secondsToClose:Int = 15){
		
		self.secondsToOpen = Double(secondsToOpen)
		self.secondsToClose = Double(secondsToClose)
		self.hardwareTrigger = EBool(&hardwarePuls)		
		super.init()
		
		currentPositionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
			self.updateCurrentPosition()
		}
		
	}
	
	private func updateCurrentPosition() {
		
		if (self.currentPosition != nil){
			
			if (self.positionState == .increasing) && (self.currentPosition! < 100.0){
				
				self.currentPosition! += (1/self.secondsToOpen*100.0)
				self.currentPosition! = min(self.currentPosition!, 100.0)
				
			}else if (self.positionState == .decreasing) && (self.currentPosition! > 0.0){
				
				self.currentPosition! -= (1/self.secondsToClose*100.0)
				self.currentPosition! = max(0.0, self.currentPosition!)
				
			}
						
		}
		
		
	}
	
	private func readPositionStateFromFeedbacks(){
		
		// Currentposition will be updated by the currentPositionTimer in a timely fashion,
		// but synchronise the targetposition and positionstate with the new hardwarefeedback
		if (hardwareFeedbackIsOpening == true)  && (hardwareFeedbackIsClosing == false){
			self.positionState = .increasing
		}else if (hardwareFeedbackIsClosing == true) && (hardwareFeedbackIsOpening == false){
			self.positionState = .decreasing
		}else if (hardwareFeedbackIsClosing == false) && (hardwareFeedbackIsOpening == false){
			self.positionState = .stopped
			
		}
		
		if (self.positionState == .stopped) && (abs(self.deviation) < deadband){
			self.targetPosition = currentPosition!
		}
				
	}
	
	// MARK: - HomeKit Accessory binding
	
	typealias AccessorySubclass = Accessory.WindowCovering
	
	private var characteristicChanged:Bool = false
	var hkAccessoryTargetPosition:UInt8 = 100{
		didSet{
			// Only when circuit is idle
			// send the hardwareFeedback upstream to the Homekit accessory,
			// provides for a more stable hardwareFeedback
			if  !characteristicChanged && !hardwareFeedbackChanged{
				accessory.windowCovering.targetPosition.value = hkAccessoryTargetPosition
			}
		}
	}
	var hkAccessoryCurrentPosition:UInt8 = 100{
		didSet{
			// Only when circuit is idle
			// send the hardwareFeedback upstream to the Homekit accessory,
			// provides for a more stable hardwareFeedback
			if  !characteristicChanged && !hardwareFeedbackChanged{
				accessory.windowCovering.currentPosition.value = hkAccessoryCurrentPosition
			}
		}
	}
	
	var hkAccessoryPositionState:Enums.PositionState = .stopped{
		didSet{
			// Only when circuit is idle
			// send the hardwareFeedback upstream to the Homekit accessory,
			// provides for a more stable hardwareFeedback
			if  !characteristicChanged && !hardwareFeedbackChanged{
				accessory.windowCovering.positionState.value = hkAccessoryPositionState
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
			case CharacteristicType.targetPosition:
				hkAccessoryTargetPosition = value as? UInt8 ?? hkAccessoryTargetPosition
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
	}
	
	// MARK: - PLC IO-Signal assignment
	
	var outputSignal:DigitalOutputSignal{
		plc.signal(ioSymbol:instanceName) as! DigitalOutputSignal
	}
	
	var feedbackSignalIsOpening:DigitalInputSignal?{
		
		plc.signal(ioSymbol:instanceName+" Open") as? DigitalInputSignal
		
	}
	
	var feedbackSignalIsClosing:DigitalInputSignal?{
		
		plc.signal(ioSymbol:instanceName+" Close") as? DigitalInputSignal
		
	}
	
	public func assignInputParameters(){
		
		hardwareFeedbackIsOpening = feedbackSignalIsOpening?.logicalValue
		hardwareFeedbackIsClosing = feedbackSignalIsClosing?.logicalValue
		readPositionStateFromFeedbacks()
		
		// MARK: - PLC parameter assignment
		
		if (currentPosition == nil) && hardwareFeedbackChanged{
			
			if self.positionState == .increasing{
				currentPosition = 100.0
			}else if self.positionState == .decreasing{
				currentPosition = 0.0
			}else if self.positionState == . stopped{
				currentPosition = 50.0
			}
			self.targetPosition = currentPosition!
			
		}else if (currentPosition != nil) && characteristicChanged{
			
			targetPosition = Double(hkAccessoryTargetPosition)
			
		}else if (currentPosition != nil) && hardwareFeedbackChanged{
			
			if self.positionState == .increasing{
				targetPosition = 100.0
			}else if self.positionState == .decreasing{
				targetPosition = 0.0
			}else if (self.positionState == . stopped){
				targetPosition = currentPosition!
			}
			
		}
		
	}
	
	public func assignOutputParameters(){
		outputSignal.logicalValue = puls
		
		hkAccessoryCurrentPosition = UInt8(currentPosition ?? 50.0)
		hkAccessoryTargetPosition = UInt8(targetPosition)
		hkAccessoryPositionState = positionState
		
		characteristicChanged.reset()
	}
	
	var hardwareFeedbackIsOpening:Bool?{
		didSet{
			hardwareFeedbackIsOpeningChanged = (hardwareFeedbackIsOpening != oldValue) && (hardwareFeedbackIsOpening != nil)
		}
	}
	var hardwareFeedbackIsClosing:Bool?{
		didSet{
			hardwareFeedbackIsClosingChanged = (hardwareFeedbackIsClosing != oldValue) && (hardwareFeedbackIsClosing != nil)
		}
	}
	private var hardwareFeedbackIsOpeningChanged:Bool = false
	private var hardwareFeedbackIsClosingChanged:Bool = false
	private var hardwareFeedbackChanged:Bool{
		// Don't capture any changes in hardware feedback that originated after a puls from this accesory
		let notHandlingPuls:Bool = (!outputSignal.logicalValue && !pulsTimer.input)
		return notHandlingPuls && (hardwareFeedbackIsOpeningChanged || hardwareFeedbackIsClosingChanged)
	}
	
	// MARK: - PLC Processing
	private var currentPosition:Double? = nil
	private var currentPositionTimer:Timer!
	private var targetPosition:Double = 100.0
	private var positionState:Enums.PositionState = .stopped
	private let secondsToOpen:Double
	private let secondsToClose:Double
	private var deviation:Double{
		if let currentPosition = self.currentPosition{
			return currentPosition-targetPosition
		}else{
			return 0
		}
	}
	private var deadband:Double{
		if (targetPosition < 1.0) || (targetPosition > 99.0){
			return 0.0
		}else{
			return 100/min(secondsToOpen, secondsToClose)
		}
	}
	
	let pulsTimer = DigitalTimer.PulsLimition(time: 0.25)
	var puls:Bool{
		get{
			
			let shouldOpen:Bool = (deviation < -deadband) && (hardwareFeedbackIsOpening == false)
			let shouldClose:Bool = (deviation > +deadband) && (hardwareFeedbackIsClosing == false)
			// Only stop in between end-positions
			let shouldStop:Bool = (targetPosition > 0.0) && (targetPosition < 100.0) && (abs(deviation) <= deadband) && ( (hardwareFeedbackIsOpening == true) || (hardwareFeedbackIsClosing == true) )
			
			// Only toggle if the state and its hardwareFeedback are not already in sync
			var puls =  !outputSignal.logicalValue && (shouldOpen || shouldClose || shouldStop )
			
			return puls.timed(using: pulsTimer)
		}
	}
	
	// MARK: - Simulation hardware
	
	// When in simulation mode,
	// provide the hardwarefeedback yourself
	private var hardwarePuls:Bool = false
	private var hardwareTrigger:EBool
	
	private var hardwareState:WindowCoveringState = .stoppedAfterOpening
	private enum WindowCoveringState{
		
		case opening
		case stoppedAfterOpening
		case closing
		case stoppedAfterClosing
		
		func nextState()->Self{
			
			switch self{
				case .opening:
					return .stoppedAfterOpening
				case .stoppedAfterOpening:
					return .closing
				case .closing:
					return .stoppedAfterClosing
				case .stoppedAfterClosing:
					return .opening
			}
		}
		
	}
	
	public func simulateHardwareFeedback() {
		
		hardwarePuls = outputSignal.logicalValue
		
		if hardwareTrigger.🔼{
			hardwareState = hardwareState.nextState()
		}
		feedbackSignalIsOpening?.ioValue = (hardwareState == .opening)
		feedbackSignalIsClosing?.ioValue = (hardwareState == .closing)
		
	}
	
}


