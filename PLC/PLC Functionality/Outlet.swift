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

// MARK: - Accesory bindings
extension Outlet:AccessoryDelegate, AccessorySource{
	
	typealias AccessorySubclass = Accessory.Outlet
	func handleCharacteristicChange<T>(accessory:Accessory,
									   service: Service,
									   characteristic: GenericCharacteristic<T>,
									   to value: T?){
		
		// Handle Characteristic change depending on its type
		switch characteristic.type{
			case CharacteristicType.powerState:
				
				accessoryPowerState = value as? Bool ?? accessoryPowerState
				
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
		
		characteristicChanged.set()
	}
	
	public func writeCharacteristic<T>(_ characteristic:GenericCharacteristic<T>, to value: T?) {
		
		switch characteristic.type{
			case CharacteristicType.powerState:
				
				accessory.outlet.powerState.value = value as? Bool
				
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
	}
	
}

// MARK: - PLC level class
public class Outlet:PLCclass, Parameterizable{
	
	// MARK: - State
	public var powerState:Bool? = nil
	
	// Accessory state
	private var accessoryPowerState:Bool = true
	private var characteristicChanged:Bool = false
	
	// Hardware feedback state
	private var hardwarePowerState:Bool?{
		didSet{
			hardwareFeedbackChanged = (oldValue != nil) && (hardwarePowerState != nil) && (hardwarePowerState != oldValue)
		}
	}
	private var hardwareFeedbackChanged:Bool = false
	
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
		plc.signal(ioSymbol:instanceName) as! DigitalOutputSignal
	}
	
	// MARK: - Parameter assignment	
	public func assignInputParameters(){
		
		outputSignal.outputLogic = .inverse
		hardwarePowerState = outputSignal.logicalFeedbackValue
		
		if (powerState == nil) && (hardwarePowerState != nil){
			powerState = hardwarePowerState
		}else if (powerState != nil) && characteristicChanged{
			powerState = accessoryPowerState
		}else if (powerState != nil) && hardwareFeedbackChanged{
			powerState = hardwarePowerState
		}else if let newAccessoryPowerSate = powerState{
			// Only write back to the Homekit accessory,
			// when the circuit is completely idle
			// (this garantees a stable user experience)
			writeCharacteristic(accessory.outlet.powerState, to: newAccessoryPowerSate)
			if instanceName == "Buiten Stopcontact"{
				print("***send upstream")
			}
		}
		
	}
	
	public func assignOutputParameters(){
		outputSignal.logicalValue = powerState ?? false
		
		accessoryPowerState = powerState ?? false
		characteristicChanged.reset()
	}
	
}
