//
//  PLCClassAccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 01/10/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVSwift
import SoftPLC
import OSLog

// MARK: - PLC Accessory Delegate
/// The only thing the PLCAccessoryDelegate does is pass a 'characteristicChanged'-bit down the chain, to
/// the PLC-Object that has the same name as the accessory and that will act as the final AccessoryDelegate.
///
/// Also most of the functionality that is normally required for an AccessoryDelegate
/// is already implemented by the PLC and the PLC-Classes by default,
/// making large parts of the protocol optional.

class PLCAccessoryDelegate:AccessoryDelegate {}

extension AccessoryDelegate where Self:PLCAccessoryDelegate{
        
    var name: String {""}
    
    var characteristicChanged:Bool{
        get{false}
        set{}
    }
    
    func handleCharacteristicChange<T>(accessory:AccessorySubclass,
                                       service: Service,
                                       characteristic: GenericCharacteristic<T>,
                                       to value: T?){
        if let plcObject = MainConfiguration.PLC.PLCobjects[accessory.info.name.value ?? ""] as? any AccessoryDelegate{
            plcObject.characteristicChanged.set()
        }
        
    }
}


// MARK: - PLCClass Accessory Delegate
extension AccessoryDelegate where Self:PLCClass{
    
    public var name:String{
        self.instanceName
    }
    
    func handleCharacteristicChange<T>(accessory:AccessorySubclass, service: HAP.Service, characteristic: HAP.GenericCharacteristic<T>, to value: T?){
        // Dummy method
        // The actual characteristic changes are handled by the PLCClasses in a cyclic manner not through this event
    }
}

extension AccessorySource where Self:PLCClass{
    // Dummy method
    // A PLC-class already has a runCycle so there is no need to implement the extra pollCycle
    func pollCycle(){}
}

typealias PLCClassAccessoryDelegate = PLCClass & Parameterizable & CyclicRunnable & AccessoryDelegate & AccessorySource


// MARK: -
protocol PulsOperatedCircuit{
    
    associatedtype DigitalTimerType
    
    var pulsTimer:DigitalTimerType { get }
    var puls:Bool { get }
    
}
