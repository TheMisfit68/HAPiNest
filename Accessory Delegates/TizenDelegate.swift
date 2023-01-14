//
//  TizenDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 03/03/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import TizenDriver

class TizenDelegate:TizenDriver, AccessoryDelegate, AccessorySource, CyclicPollable{
	
	var name: String{
		super.tvName
	}
	
	// Accessory binding
	typealias AccessorySubclass = Accessory.Television
	var characteristicChanged:Bool = false
	
	func handleCharacteristicChange<T>(accessory:Accessory,
									   service: Service,
									   characteristic: GenericCharacteristic<T>,
									   to value: T?){
		
		// Handle Characteristic change depending on its type
		switch characteristic.type{
				
			case CharacteristicType.active:
				
				let status = value as! Enums.Active
				switch status{
					case .active:
						super.powerOn()
					case .inactive:
						super.powerOff()
				}
				
				
			case CharacteristicType.activeIdentifier:
				
				// Use 'InputSource'-selector to switch channels instead
				let channelNumber = value as! UInt32
				switch channelNumber {
						
					case 11:
						super.openApp(.Netflix)
					case 12:
						super.openApp(.YouTube)
					case 13:
						super.openURL("http://192.168.0.10:8001/live?cameraNum=0&viewMethod=0&windowWidth=1920&windowHeight=840&auth=R1VFU1Q6R1VFU1Q=")
					case 14:
						super.openURL("http://192.168.0.10:8001/live?cameraNum=2&viewMethod=0&windowWidth=1920&windowHeight=840&auth=R1VFU1Q6R1VFU1Q=")
					default:
						super.gotoChannel(Int(channelNumber))
				}
				
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
				
		}
		characteristicChanged.set()
	}
	
	// MARK: - State
	public var activeState:Enums.Active? = nil
	var activeIdentifier:Int? = nil
	
	// Hardware feedback state
	private var hardwareActiveState:Enums.Active?{
		didSet{
			hardwareFeedbackChanged.set(  (hardwareActiveState != nil) && (oldValue != nil) && (hardwareActiveState != oldValue) )
		}
	}
	var hardwareFeedbackChanged:Bool = false
	
	func pollCycle() {
		
		// Constantly check the T.V.'s reachability
		let reachability = super.tvIsReachable

		// But don't replicate it into the hardwareActiveState during (unstable) power transitions
		if (powerState != .poweringUp) && (powerState != .poweringDown){
			hardwareActiveState = reachability ? .active : .inactive
		}
		
		reevaluate(&activeState, characteristic: accessory.television.active, hardwareFeedback: hardwareActiveState)
		reevaluate(&activeIdentifier, characteristic: accessory.television.activeIdentifier, hardwareFeedback: nil)
		
		characteristicChanged.reset()
		hardwareFeedbackChanged.reset()
	}
	
}

