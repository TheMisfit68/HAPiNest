//
//  PLCClassAccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 01/10/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import SoftPLC
import OSLog

// MARK: - PLC Accessory Delegate
/// The only thing the PLCAccessoryDelegate does is pass a 'characteristicChanged'-bit down the chain, to
/// the PLC-Object (that has the same name as the accessory) and that will act as the final delegate.
class PLCAccessoryDelegate:AccessoryDelegate {
    
    var name: String = "PLCAccessoryDelegate"
    
    public var characteristicChanged:Bool = false{
        didSet{
            characteristicChanged = false
        }
    }
    
    func handleCharacteristicChange<T>(accessory:Accessory,
                                       service: Service,
                                       characteristic: GenericCharacteristic<T>,
                                       to value: T?){
        if let plcObject = MainConfiguration.PLC.PLCobjects[accessory.name] as? any AccessoryDelegate{
            plcObject.characteristicChanged.set()
        }
          
    }
    
}


// MARK: - PLCClass Accessory Delegate
extension AccessoryDelegate where Self:PLCClass{
    
    public var name:String{
        self.instanceName
    }
    
    func handleCharacteristicChange<T>(accessory:HAP.Accessory, service: HAP.Service, characteristic: HAP.GenericCharacteristic<T>, to value: T?){
        // Dummy method
        // The actual characteristic changes are handled by the PLCClasses in a cyclic manner not through this event
    }
}


typealias PLCClassAccessoryDelegate = PLCClass & Parameterizable & CyclicRunnable & AccessoryDelegate & AccessorySource


// MARK: -
protocol PulsOperatedCircuit{
    
    associatedtype DigitalTimerType
    
    var pulsTimer:DigitalTimerType { get }
    var puls:Bool { get }
    
}
