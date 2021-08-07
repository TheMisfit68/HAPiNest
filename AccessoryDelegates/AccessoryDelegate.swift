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

// A Class capable of receving events from a HomeKit-Accessory
protocol AccessoryDelegate: AnyObject{
	
	var name:String{get}
	var characteristicChanged:Bool{get set}
	func handleCharacteristicChange<T>(accessory:Accessory,
									   service: Service,
									   characteristic: GenericCharacteristic<T>,
									   to value: T?)
}

extension AccessoryDelegate{
	
	func handleCharacteristicChange<T>(accessory:Accessory,
									   service: Service,
									   characteristic: GenericCharacteristic<T>,
									   to value: T?){
		characteristicChanged.set()
	}
	
}

extension AccessoryDelegate where Self:PLCClass{
	
	var name:String{
		self.instanceName
	}
	
}


// A Class capable of writing values to a HomeKit-Accessory
protocol AccessorySource:AccessoryDelegate{
	
	var hardwareFeedbackChanged:Bool{get set}
	
	associatedtype AccessorySubclass
	var accessory:AccessorySubclass{get}
	
	func reevaluate<PT, CT>(_ property:inout PT?, initialValue:PT?, characteristic:GenericCharacteristic<CT>?, hardwareFeedback:PT?, typeTranslators:((CT)->PT, (PT)->CT)?)

}

extension AccessorySource{
	
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
