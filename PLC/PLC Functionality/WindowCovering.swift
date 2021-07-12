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

// MARK: - Accessory bindings
extension WindowCovering:AccessoryDelegate, AccessorySource{
	
	typealias AccessorySubclass = Accessory.WindowCovering
	
	func handleCharacteristicChange<T>(accessory:Accessory,
									   service: Service,
									   characteristic: GenericCharacteristic<T>,
									   to value: T?){
		
		// Handle Characteristic change depending on its type
		switch characteristic.type{
			case CharacteristicType.targetPosition:
				accessoryTargetPosition = value as? UInt8 ?? accessoryTargetPosition
				
				
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
		
		characteristicChanged.set()
	}
	
	public func writeCharacteristic<T>(_ characteristic:GenericCharacteristic<T>, to value: T?) {
		
		switch characteristic.type{
			case CharacteristicType.targetPosition:
				
				accessory.windowCovering.targetPosition.value = value as? UInt8
				
			case CharacteristicType.currentPosition:
				
				accessory.windowCovering.currentPosition.value = value as? UInt8
				
			case CharacteristicType.positionState:
				
				accessory.windowCovering.positionState.value = value as? Enums.PositionState
				
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
	}
	
}

// MARK: - PLC level class
class WindowCovering:PLCclass, Parameterizable, Simulateable, PulsOperatedCircuit{
	
	// MARK: - State
	private var targetPosition:Int? = 100
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
	
	// Accessory state
	private var accessoryTargetPosition:UInt8 = 100
	private var accessoryCurrentPosition:UInt8 = 100
	private var accessoryPositionState:Enums.PositionState = .stopped
	private var characteristicChanged:Bool = false
	
	// Hardware feedback state
	var hardwareFeedbackIsOpening:Bool?{
		didSet{
			let hardwareFeedbackIsOpeningChanged = (hardwareFeedbackIsOpening != nil) && (oldValue != nil) && (hardwareFeedbackIsOpening != oldValue)
			// Don't capture any changes in hardware feedback that originated after a puls from this accesory
			hardwareFeedbackChanged.setConditional( hardwareFeedbackIsOpeningChanged &&
												   (!outputSignal.logicalValue && !pulsTimer.input) )
		}
	}
	var hardwareFeedbackIsClosing:Bool?{
		didSet{
			let hardwareFeedbackIsClosingChanged = (hardwareFeedbackIsClosing != nil) && (oldValue != nil) && (hardwareFeedbackIsClosing != oldValue)
			// Don't capture any changes in hardware feedback that originated after a puls from this accesory
			hardwareFeedbackChanged.setConditional( hardwareFeedbackIsClosingChanged &&
													(!outputSignal.logicalValue && !pulsTimer.input) )
		}
	}
	private var hardwareFeedbackChanged:Bool = false
	
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
		
		if (self.currentPosition != nil){
			
			if (self.positionState == .increasing) && (self.currentPosition! < 100.0){
				
				self.currentPosition! += (1/self.secondsToOpen)*100.0
				self.currentPosition! = min(self.currentPosition!, 100.0)
				
			}else if (self.positionState == .decreasing) && (self.currentPosition! > 0.0){
				
				self.currentPosition! -= (1/self.secondsToClose)*100.0
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
		
		if (self.positionState == .stopped) && (abs(self.deviation) < deadband),
			let currentPosition = self.currentPosition{
			
			self.targetPosition = Int(currentPosition)
			
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
		readPositionStateFromFeedbacks()
		
		if (currentPosition == nil) && (positionState != nil){
			if positionState == .increasing{
				currentPosition = 100.0
			}else if positionState == .decreasing{
				currentPosition = 0.0
			}else if positionState == . stopped{
				currentPosition = 50.0
			}
			if let currentPosition = self.currentPosition {
				self.targetPosition = Int(currentPosition)
			}
		}else if (currentPosition != nil) && characteristicChanged{
			targetPosition = Int(accessoryTargetPosition)
			characteristicChanged.reset()
		}else if (currentPosition != nil) && hardwareFeedbackChanged{
			if positionState == .increasing{
				targetPosition = 100
			}else if positionState == .decreasing{
				targetPosition = 0
			}else if positionState == . stopped,
					 let currentPosition = self.currentPosition{
				targetPosition = Int(currentPosition)
			}
			hardwareFeedbackChanged.reset()
		}else if let accessoryTargetPosition = self.targetPosition,
				 let accessoryCurrentPosition = self.currentPosition,
				 let accessoryPositionState = self.positionState{
			// Only write back to the Homekit accessory,
			// when the circuit is completely idle
			// (this garantees a more stable user experience)
			writeCharacteristic(accessory.windowCovering.targetPosition, to: UInt8(accessoryTargetPosition) )
			writeCharacteristic(accessory.windowCovering.currentPosition, to: UInt8(accessoryCurrentPosition) )
			writeCharacteristic(accessory.windowCovering.positionState, to: accessoryPositionState)
		}
		
	}
	
	public func assignOutputParameters(){
		outputSignal.logicalValue = puls
	}
	
	
	// MARK: - PLC Processing
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


