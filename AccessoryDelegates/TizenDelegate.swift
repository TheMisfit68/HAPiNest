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

// MARK: - Accessory bindings
extension TizenDelegate:AccessoryDelegate, AccessorySource{
	
	var name: String {
		self.tvName
	}
	
	typealias AccessorySubclass = Accessory.Television
    
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
					powerState = .poweringUp
            case .inactive:
					powerState = .poweringDown
            }
            
            
        case CharacteristicType.activeIdentifier:
            
            // Use 'InputSource'-selector to switch channels instead
            let channelNumber = value as! UInt32
            switch channelNumber {
            //            case 11:
            //                // NetFlix
            //                let appCommand = TizenCommand(rawValue:"KEY_HDMI")!
            //
            //
            //            case 12:
            //                // YouTube
            //                let appCommand = TizenCommand(rawValue:"KEY_HDMI")!
            
            default:
                if let keyCommand = TizenCommand(rawValue:"KEY_\(channelNumber)"){
                    
                    let hdmiSourceCommand = TizenCommand(rawValue:"KEY_HDMI")!
                    queue(commands:[hdmiSourceCommand, keyCommand])
                }
            }
            
        default:
            Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
            
        }
		characteristicChanged.set()
    }
	
	func writeCharacteristic<CT, PT>(_ characteristic: GenericCharacteristic<CT>,
								to value: PT){
		
		switch characteristic.type{
			case CharacteristicType.active:
				
				accessory.television.active.value = value as? Enums.Active
				
			default:
				Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
		}
	}
	
}

class TizenDelegate:TizenDriver{
	
	// MARK: - State
	override var powerState:PowerState{
		
		get{ return super.powerState }
		
		set{
			super.powerState = newValue
			if  super.powerState == .poweredOn{
				writeCharacteristic(accessory.television.active, to: HAP.Enums.Active.active)
			}else if super.powerState == .poweredOff{
				writeCharacteristic(accessory.television.active, to: HAP.Enums.Active.inactive)
			}
		}
	
	}
	
//	public var powerState:PowerState? = nil
	
	// Accessory state
	private var accessoryPowerState:PowerState = .undefined
	var characteristicChanged:Bool = false

	// Hardware feedback state
	private var hardwarePowerState:Bool?{
		didSet{
			hardwareFeedbackChanged = (hardwarePowerState != nil) && (oldValue != nil) &&  (hardwarePowerState != oldValue)
		}
	}
	var hardwareFeedbackChanged:Bool = false
	
}

