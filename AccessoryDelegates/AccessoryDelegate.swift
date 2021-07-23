//
//  AccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 29/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import SoftPLC

// A type capable of receving events from a HomeKit-Accessory
protocol AccessoryDelegate{
	
	var name:String{get}
	func handleCharacteristicChange<T>(accessory:Accessory,
									   service: Service,
									   characteristic: GenericCharacteristic<T>,
									   to value: T?)
	var characteristicChanged:Bool{get set}
}

extension AccessoryDelegate where Self:PLCClass{
	
	var name:String{
		self.instanceName
	}
	
}

protocol AccessorySource:AccessoryDelegate{
	
	var hardwareFeedbackChanged:Bool{get set}
	
	associatedtype AccessorySubclass
	var accessory:AccessorySubclass{get}
	
	
	func writeCharacteristic<T>(_ characteristic: GenericCharacteristic<T>,
								to value: T?)
}

// A type capable of writing values to a HomeKit-Accessory
extension AccessorySource{
	
	var accessory:AccessorySubclass{
		HomeKitServer.shared.mainBridge[name] as! AccessorySubclass
	}
	
	func reevaluate<T>(_ property:inout T?, initialValue:T? = nil, characteristic:GenericCharacteristic<T>?, hardwareFeedback:T?){
		
		if (property == nil), let initialValue = initialValue{
			property = initialValue
		}else if (property == nil), let initialValue = hardwareFeedback{
			property = initialValue
		}else if (property != nil) && characteristicChanged, let characteristictValue = characteristic?.value {
			property = characteristictValue
		}else if (property != nil) && hardwareFeedbackChanged, let hardwareValue = hardwareFeedback{
			property = hardwareValue
		}else if let characteristic = characteristic, let characteristictValue = property{
			// Only write back to the Homekit accessory,
			// when the circuit is completely idle
			// (this garantees a more stable user experience)
			writeCharacteristic(characteristic, to: characteristictValue)
		}
		
	}
	
}
