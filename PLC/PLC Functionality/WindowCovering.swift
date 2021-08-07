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

// MARK: - PLC level class
class WindowCovering:PLCClass, AccessoryDelegate, AccessorySource, Parameterizable, CyclicRunnable, PulsOperatedCircuit, Simulateable{
	
	// Accessory binding
	typealias AccessorySubclass = Accessory.WindowCovering
	var characteristicChanged:Bool = false
	
	// MARK: - State
	private var targetPosition:Int? = 100 // Default to open on startup, not to current state
	private var currentPosition:Float? = nil
	private var positionState:Enums.PositionState? = .stopped
	
	private var currentPositionTimer:Timer!
	private let secondsToOpen:Float
	private let secondsToClose:Float
	private var deviation:Float{
		if let targetPosition = self.targetPosition, let currentPosition = self.currentPosition{
			return currentPosition-Float(targetPosition)
		}else{
			return 0
		}
	}
	private var deadband:Float{
		if let targetPosition = self.targetPosition, (targetPosition < 1) || (targetPosition > 99){
			return 0.0
		}else{
			return 100/min(secondsToOpen, secondsToClose)
		}
	}
	
	// Hardware feedback state
	var hardwareFeedbackIsOpening:Bool?{
		didSet{
			let hardwareFeedbackIsOpeningChanged = (hardwareFeedbackIsOpening != nil) && (oldValue != nil) && (hardwareFeedbackIsOpening != oldValue)
			//Don't capture any changes in hardware feedback that originated after a puls from this accesory
			hardwareFeedbackChanged.set( hardwareFeedbackIsOpeningChanged &&
										 (!outputSignal.logicalValue && !pulsTimer.input) )
		}
	}
	var hardwareFeedbackIsClosing:Bool?{
		didSet{
			let hardwareFeedbackIsClosingChanged = (hardwareFeedbackIsClosing != nil) && (oldValue != nil) && (hardwareFeedbackIsClosing != oldValue)
			// Don't capture any changes in hardware feedback that originated after a puls from this accesory
			hardwareFeedbackChanged.set( hardwareFeedbackIsClosingChanged &&
										 (!outputSignal.logicalValue && !pulsTimer.input) )
			
		}
	}
	var hardwareFeedbackChanged:Bool = false
	
	private var hardwarePositionState:Enums.PositionState{
		
		if (hardwareFeedbackIsOpening == true)  && (hardwareFeedbackIsClosing == false){
			return .increasing
		}else if (hardwareFeedbackIsClosing == true) && (hardwareFeedbackIsOpening == false){
			return .decreasing
		}else{
			return .stopped
		}
		
	}
	
	private var hardwareTargetPosition:Int?{
				
		if hardwareFeedbackChanged && (hardwarePositionState == .increasing){
			return 100
		}else if hardwareFeedbackChanged && (hardwarePositionState == .decreasing){
			return 0
		}else if hardwarePositionState == .stopped, let currentPosition = self.currentPosition{
			return Int(currentPosition)
		}else{
			return nil
		}
		
	}
	
	init(secondsToOpen:Int = 15, secondsToClose:Int = 15){
		
		self.secondsToOpen = Float(secondsToOpen)
		self.secondsToClose = Float(secondsToClose)
		self.hardwareTrigger = EBool(&hardwarePuls)
		super.init()
		
		currentPositionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
			self.updateCurrentPosition()
		}
		
	}
	
	// MARK: - Subroutines
	private func updateCurrentPosition() {
		
		if (self.currentPosition == nil){
			
			if (hardwarePositionState == .increasing){
				
				self.currentPosition = 100.0
				
			}else if (hardwarePositionState == .decreasing){
				
				self.currentPosition = 0.0
				
			}else if (hardwarePositionState == .stopped){
				
				self.currentPosition = 50.0
				
			}
			
			
		}else{
			
			if (hardwarePositionState == .increasing) && (self.currentPosition! < 100.0){
				
				self.currentPosition! += (1/self.secondsToOpen)*100.0
				self.currentPosition! = min(self.currentPosition!, 100.0)
				
			}else if (hardwarePositionState == .decreasing) && (self.currentPosition! > 0.0){
				
				self.currentPosition! -= (1/self.secondsToClose)*100.0
				self.currentPosition! = max(0.0, self.currentPosition!)
				
			}else if (hardwarePositionState == .stopped) && (abs(self.deviation) < deadband), let currentPosition = self.currentPosition{
				self.targetPosition = Int(currentPosition)
			}
			
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
	
	// MARK: - Parameter assignment
	public func assignInputParameters(){
		hardwareFeedbackIsOpening = feedbackSignalIsOpening?.logicalValue
		hardwareFeedbackIsClosing = feedbackSignalIsClosing?.logicalValue
	}
	
	public func assignOutputParameters(){
		outputSignal.logicalValue = puls
	}
	
	
	// MARK: - PLC Processing
	func runCycle() {
		
		reevaluate(&positionState, initialValue: hardwarePositionState,
				   characteristic:accessory.windowCovering.positionState, hardwareFeedback: hardwarePositionState)
		reevaluate(&currentPosition, characteristic:accessory.windowCovering.currentPosition, hardwareFeedback:nil, typeTranslators: ( {Float($0)} , {UInt8($0)} ) )
		reevaluate(&targetPosition, characteristic:accessory.windowCovering.targetPosition, hardwareFeedback: hardwareTargetPosition,
				   typeTranslators: ( {Int($0)} , {UInt8($0)} )
		)
		
		characteristicChanged.reset()
		hardwareFeedbackChanged.reset()
		
	}
	
	let pulsTimer = DigitalTimer.PulsLimition(time: 0.25)
	var puls:Bool{
		get{
			
			let shouldOpen:Bool = (deviation < -deadband) && (hardwareFeedbackIsOpening == false)
			let shouldClose:Bool = (deviation > +deadband) && (hardwareFeedbackIsClosing == false)
			// Only stop in between end-positions
			let shouldStop:Bool = (targetPosition != nil) && (targetPosition! > 0) && (targetPosition! < 100) && (abs(deviation) <= deadband) && ( (hardwareFeedbackIsOpening == true) || (hardwareFeedbackIsClosing == true) )
			
			// Only toggle if the state and its hardwareFeedback are not already in sync
			var puls =  !outputSignal.logicalValue && (shouldOpen || shouldClose || shouldStop )
			
			return puls.timed(using: pulsTimer)
		}
	}
	
	// MARK: - Hardware simulation
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
	
	public func simulateHardwareInputs() {
		
		hardwarePuls = outputSignal.logicalValue
		
		if hardwareTrigger.🔼{
			hardwareState = hardwareState.nextState()
		}
		feedbackSignalIsOpening?.ioValue = (hardwareState == .opening)
		feedbackSignalIsClosing?.ioValue = (hardwareState == .closing)
		
	}
	
}



