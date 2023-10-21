//
//  PLCClassAccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 26/12/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import SoftPLC
import HAP

// MARK: - PLCClass based Accessory Delegate

extension AccessoryDelegate where Self:PLCClass{
    
    public var name:String{
        self.instanceName
    }
    
    func handleCharacteristicChange<T>(accessory:HAP.Accessory, service: HAP.Service, characteristic: HAP.GenericCharacteristic<T>, to value: T?){
        // Dummy method
        // The actual characteristic changes are handled by the PLCClasses in a cyclic manner not through this event
    }
}

// Any object capable of reacting to changes in the field
protocol CyclicPollable:AccessorySource{
    
    func pollCycle()
    
}

typealias PLCClassAccessoryDelegate = PLCClass & Parameterizable & CyclicRunnable & AccessoryDelegate & AccessorySource

protocol PulsOperatedCircuit{
    
    associatedtype DigitalTimerType
    
    var pulsTimer:DigitalTimerType { get }
    var puls:Bool { get }
    
}
