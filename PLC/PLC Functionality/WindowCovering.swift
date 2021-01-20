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
import JVCocoa

class WindowCovering:PLCclass, Parameterizable, Simulateable, AccessoryDelegate, AccessorySource, PulsOperatedCircuit{
	
	 init(secondsToOpen:Int = 15, secondsToClose:Int = 15){
		
		self.secondsToOpen = Double(secondsToOpen)
		self.secondsToClose = Double(secondsToClose)
		
		super.init()
		
		currentPositionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
			if self.hardwareFeedbackIsOpening{
				self.currentPosition = min(self.currentPosition+(1/self.secondsToOpen*100.0), 100.0)
			}else if self.hardwareFeedbackIsClosing{
				self.currentPosition = max(0, self.currentPosition-(1/self.secondsToClose*100.0))
			}
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
			if  !characteristicChanged{
				accessory.windowCovering.targetPosition.value = hkAccessoryTargetPosition
			}
		}
	}
	var hkAccessoryCurrentPosition:UInt8 = 100{
		didSet{
			// Only when circuit is idle
			// send the hardwareFeedback upstream to the Homekit accessory,
			// provides for a more stable hardwareFeedback
			if  !characteristicChanged{
				accessory.windowCovering.currentPosition.value = hkAccessoryCurrentPosition
			}
		}
	}
	
	var hkAccessoryPositionState:Enums.PositionState = .stopped{
		didSet{
			// Only when circuit is idle
			// send the hardwareFeedback upstream to the Homekit accessory,
			// provides for a more stable hardwareFeedback
			if  !characteristicChanged{
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
	
	// MARK: - PLC parameter assignment
	
	public func assignInputParameters(){
		
		hardwareFeedbackIsOpening = feedbackSignalIsOpening?.logicalValue ?? false
		hardwareFeedbackIsClosing = feedbackSignalIsClosing?.logicalValue ?? false
		
		if characteristicChanged{
			if instanceName == "Living Screens"{
				print("***new position \(hkAccessoryTargetPosition)")
			}
			targetPosition = hkAccessoryTargetPosition
		}else if hardwareFeedbackChanged{
			
			if hardwareFeedbackIsOpening{
				positionState = .increasing
			}else if hardwareFeedbackIsClosing{
				positionState = .decreasing
			}else{
				positionState = .stopped
				targetPosition = UInt8(currentPosition)
			}
			
		}
		
	}
	
	public func assignOutputParameters(){
		outputSignal.logicalValue = puls
		
		hkAccessoryTargetPosition = targetPosition
		hkAccessoryCurrentPosition = UInt8(currentPosition)
		hkAccessoryPositionState = positionState
		characteristicChanged.reset()
	}
	
	var hardwareFeedbackIsOpening:Bool = false{
		didSet{
			hardwareFeedbackChanged = (hardwareFeedbackIsOpening != oldValue)
		}
	}
	var hardwareFeedbackIsClosing:Bool = false{
		didSet{
			hardwareFeedbackChanged = (hardwareFeedbackIsClosing != oldValue)
		}
	}
	private var hardwareFeedbackChanged:Bool = false
	
	var hardwareFeedbackIsStopped:Bool{
		!hardwareFeedbackIsOpening && !hardwareFeedbackIsClosing
	}
	
	// MARK: - PLC Processing
	private var targetPosition:UInt8 = 100
	private var currentPositionTimer:Timer!
	private var currentPosition:Double = 100.0
	private let secondsToOpen:Double
	private let secondsToClose:Double
	private var positionState:Enums.PositionState = .stopped
	
	let pulsTimer = DigitalTimer.PulsLimition(time: 0.25)
	var puls:Bool{
		get{
			let deviation:Double = Double(currentPosition)-Double(targetPosition)
			var deadband:Double{
				if (targetPosition != 0) && (targetPosition != 100){
					return 100/min(secondsToOpen, secondsToClose)
				}else{
					return 0
				}
			}
			let shouldOpen:Bool = deviation < -deadband
			let shouldStop:Bool = abs(deviation) <= deadband
			let shouldClose:Bool = deviation > +deadband
			
			if instanceName == "Living Screens"{
				print("***position \(self.currentPosition)-\(self.targetPosition) = \(deviation) => \(shouldOpen)|\(shouldStop)|\(shouldClose) \(hardwareFeedbackIsOpening)|\(hardwareFeedbackIsStopped)|\(hardwareFeedbackIsClosing)")
			}
			
			// Only toggle if the state and its hardwareFeedback are not already in sync
			var puls =  !outputSignal.logicalValue && ( (shouldOpen && !hardwareFeedbackIsOpening) ||
															(shouldStop && !hardwareFeedbackIsStopped) ||
															(shouldClose && !hardwareFeedbackIsClosing) )
			
			
			
			let test = puls.timed(using: pulsTimer)
			if instanceName == "Living Screens"{
				if test{
					print("***Puls On")
				}else{
					print("****Puls Off")
				}
			}
			return test
		}
	}
	
	// MARK: - Simulation hardware
	
	// When in simulation mode,
	// provide the hardwarefeedback yourself
	private var hardwareState:WindowCoveringState = .stoppedAfterOpening
	enum WindowCoveringState{
		
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
	
	private var previousPuls:Bool = false
	public func simulateHardwareFeedback() {
		
		if puls && !previousPuls{
			hardwareState = hardwareState.nextState()
			if instanceName == "Living Screens"{
				print("***New State \(hardwareState)")
			}
		}
		previousPuls = puls
		feedbackSignalIsOpening?.logicalValue = (hardwareState == .opening)
		feedbackSignalIsClosing?.logicalValue = (hardwareState == .closing)
		
	}
	
}

