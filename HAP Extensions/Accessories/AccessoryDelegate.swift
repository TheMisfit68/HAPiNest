//
//  AccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 29/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import SoftPLC
import OSLog


// MARK: -  Accessory Delegate

// Any object capable of receving events from a HomeKit-Accessory
public protocol AccessoryDelegate: HAP.AccessoryDelegate{
	
	var name:String{get}
	var characteristicChanged:Bool{get set}
	func handleCharacteristicChange<T>(accessory:HAP.Accessory,
									   service: HAP.Service,
									   characteristic: HAP.GenericCharacteristic<T>,
									   to value: T?)
}

extension AccessoryDelegate{
	
	public func characteristic<T>(_ characteristic: HAP.GenericCharacteristic<T>,
								  ofService: HAP.Service,
								  ofAccessory: HAP.Accessory,
								  didChangeValue: T?){
        let logger = Logger(subsystem: "be.oneclick.HAPiNest", category: "AccessoryDelegate")
        
        logger.info("✴️\tValue '\(characteristic.description ?? "")' of '\(ofAccessory.info.name.value ?? "")' changed to \(String(describing:didChangeValue) )")
		characteristicChanged.set()
		
		handleCharacteristicChange(accessory:ofAccessory, service: ofService, characteristic: characteristic, to: didChangeValue)
		
	}
	
	
}

// MARK: - Accessory Source

// Any object capable of writing values to a HomeKit-Accessory
protocol AccessorySource:AccessoryDelegate{
	
	associatedtype AccessorySubclass
	var accessory:AccessorySubclass{get}
	
	var hardwareFeedbackChanged:Bool{get set}
	
	func reevaluate<PT, CT>(_ property:inout PT?, initialValue:PT?, characteristic:GenericCharacteristic<CT>?, hardwareFeedback:PT?, typeTranslators:((CT)->PT, (PT)->CT)?)
	
}

extension AccessorySource {
	
	var accessory:AccessorySubclass{
		HomeKitServer.shared.mainBridge[name] as! AccessorySubclass
	}
	
	func reevaluate<PT, CT>(_ property:inout PT?, initialValue:PT? = nil, characteristic:GenericCharacteristic<CT>?, hardwareFeedback:PT?, typeTranslators:((CT)->PT, (PT)->CT)? = nil){
		
		if (property == nil), let initialValue = initialValue{
			property = initialValue
		}else if (property == nil), let initialValue = hardwareFeedback{
			property = initialValue
		}else if (property != nil) && characteristicChanged, let characteristicvalue = characteristic?.value{
			if let propertyValue = characteristicvalue as? PT{
				property = propertyValue
			}else if let propertyValue = typeTranslators?.0(characteristicvalue){
				property = propertyValue
			}
		}else if (property != nil) && hardwareFeedbackChanged, let hardwareValue = hardwareFeedback{
			property = hardwareValue
		}else if let characteristic = characteristic, let propertyValue = property{
			
			if let characteristictValue = propertyValue as? CT{
				characteristic.value = characteristictValue
			}else if let characteristictValue = typeTranslators?.1(propertyValue){
				characteristic.value = characteristictValue
			}
			
		}
		
	}
	
}

// MARK: - PLC based Accessory Delegate

extension AccessoryDelegate where Self:PLCClass{
	
	public var name:String{
		self.instanceName
	}
	
	func handleCharacteristicChange<T>(accessory:HAP.Accessory, service: HAP.Service, characteristic: HAP.GenericCharacteristic<T>, to value: T?){
		// Characteristc are reevaluated by the PLCClasses in a cyclic manner
	}
}

// Any object capable of reacting to changes in the field
protocol CyclicPollable:AccessorySource{
	
	func pollCycle()
	
}

typealias PLCaccessoryDelegate = PLCClass & Parameterizable & CyclicRunnable & AccessoryDelegate & AccessorySource
