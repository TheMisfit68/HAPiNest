//
//  SmartSprinkler.swift
//  HAPiNest
//
//  Created by Jan Verrept on 17/01/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import Cocoa
import HAP
import SoftPLC
import ModbusDriver
import IOTypes
import JVCocoa
#if canImport(WeatherKit)
import WeatherKit
#endif

// MARK: - PLC level class
class SmartSprinkler:PLCaccessoryDelegate{
	
	// Accessory binding
	typealias AccessorySubclass = Accessory.SmartSprinkler
	var characteristicChanged:Bool = false
	
	// MARK: - State
	public var activeState:Bool? = nil
	public var programMode:Enums.ProgramMode = .programsScheduled // No way to determine this property for my 'dumb' irrigation system, so just always assume it is scheduled
	public var inUseState:Bool? = nil
	
	// Hardware feedback state
	private var hardwareInUseState:Bool?{
		didSet{
			hardwareFeedbackChanged.set( (hardwareInUseState != nil) && (oldValue != nil) &&  (hardwareInUseState != oldValue) )
		}
	}
	var hardwareFeedbackChanged:Bool = false
	
	
	
	// MARK: - IO-Signal assignment
	var outputSignal:DigitalOutputSignal{
		plc.signal(ioSymbol:instanceName) as! DigitalOutputSignal
	}
	
	
	// MARK: - Parameter assignment
	public func assignInputParameters(){
		
		outputSignal.outputLogic = .inverse
		hardwareInUseState = outputSignal.logicalFeedbackValue
		
	}
	
	public func assignOutputParameters(){

		outputSignal.logicalValue = inUseState ?? false
	}
	
	
	// MARK: - PLC Processing
	func runCycle() {
		
		// As a best effort, set the intialValue for the enable button to the latest value of the ('inUse') output
//		reevaluate(&activeState, initialValue: hardwareInUseState,  characteristic:accessory.irrigationSystem.active, hardwareFeedback: nil,
//				   typeTranslators:({$0==Enums.Active.active}, {$0 ? Enums.Active.active : Enums.Active.inactive })
//				   )
//
//		#if !canImport(WeatherKit)
//			let needsIrrigation:Bool = true
//		#else
//			var needsIrrigation:Bool = false // TODO: - Implement weatherkit data here
//		#endif
//		inUseState = ((activeState ?? false) && needsIrrigation)
//	   print("***** \(activeState) \(inUseState)")
//
//		reevaluate(&inUseState, characteristic:accessory.irrigationSystem.inUse, hardwareFeedback: hardwareInUseState,
//				   typeTranslators:({$0==Enums.InUse.inUse.rawValue}, {$0 ? Enums.InUse.inUse.rawValue : Enums.InUse.notInUse.rawValue})
//				   )
//		func handleCharacteristicChange<T>(accessory:Accessory,
//										   service: Service,
//										   characteristic: GenericCharacteristic<T>,
//										   to value: T?){
//			// overried test for protocol extension
//		}
//		
//		characteristicChanged.reset()
//		hardwareFeedbackChanged.reset()
	}
}

