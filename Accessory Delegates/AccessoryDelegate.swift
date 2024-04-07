//
//  AccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 29/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVSwift
import JVSwiftCore
import SoftPLC
import OSLog


// MARK: -  Accessory Delegate

/// An object (typically some hardware driver) capable of
/// receiving events from a HomeKit-Accessory and
/// process them accordingly.
public protocol AccessoryDelegate: HAP.AccessoryDelegate, Loggable{
    
    var name:String{get}
    
    associatedtype AccessorySubclass = Accessory
    var characteristicChanged:Bool{get set}
    func handleCharacteristicChange<T>(accessory:AccessorySubclass,
                                       service: HAP.Service,
                                       characteristic: HAP.GenericCharacteristic<T>,
                                       to value: T?)
}

extension AccessoryDelegate{
    
    public func characteristic<T>(_ characteristic: HAP.GenericCharacteristic<T>,
                                  ofService service: HAP.Service,
                                  ofAccessory accessory: HAP.Accessory,
                                  didChangeValue newValue: T?){
        
		Self.logger.info("✴️\tValue '\(characteristic.description ?? "", privacy: .public)' of '\(accessory.info.name.value ?? "", privacy: .public)/\(service.label ?? "", privacy: .public)' changed to \(String(describing:newValue), privacy: .public)")
        
        characteristicChanged.set()
        
        handleCharacteristicChange(accessory:accessory as! Self.AccessorySubclass, service: service, characteristic: characteristic, to: newValue)
        
    }
    
    
}

// MARK: - Accessory Source

/// An AccessoryDelegate also capable of
/// reading values from the field and
/// feed them back to the HomeKit-Accessory.
protocol AccessorySource:AccessoryDelegate, CyclicPollable{
        
    var accessory:AccessorySubclass{get}
    
    var hardwareFeedbackChanged:Bool{get set}
    
    func reevaluate<PT, CT>(_ property:inout PT?, initialValue:PT?, characteristic:GenericCharacteristic<CT>?, hardwareFeedback:PT?, typeTranslators:((CT)->PT, (PT)->CT)?)
    
}

extension AccessorySource {
    
    var accessory:AccessorySubclass{
        return HomeKitServer.shared.mainBridge[name] as! AccessorySubclass
    }
    
    
    /// Syncs the changes of the accessory itself and or any hardware feedback from the field into a single resulting property,
    /// keeping the the priority of changes in mind.
    /// - Parameters:
    ///   - property: the resulting property that incoporates all the changes
    ///   - initialValue: the value after a cold restart
    ///   - characteristic: the accessories characteristic that needs to be associated with this property
    ///   - hardwareFeedback: a value from the field if available
    ///   - typeTranslators: an optional tuple of two methods that translates between the type of the property and the type of the characteristic and vice versa
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

