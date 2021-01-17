//
//  DimmableLight.swift
//  HAPiNest
//
//  Created by Jan Verrept on 14/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Cocoa
import HAP
import SoftPLC
import ModbusDriver
import JVCocoa

public class DimmableLight:PLCclass, Parameterizable, AccessoryDelegate{
    
    // MARK: - HomeKit Accessory binding
    
    typealias AccessorySubclass = Accessory.Lightbulb
    
    private var characteristicChanged:Bool = false
    var hkAccessoryPowerState:Bool = false
    var hkAccessoryBrightness:Int = 100
    
    func handleCharacteristicChange<T>(accessory:Accessory,
                                       service: Service,
                                       characteristic: GenericCharacteristic<T>,
                                       to value: T?){
        characteristicChanged.set()
        
        // Handle Characteristic change depending on its type
        switch characteristic.type{
        case CharacteristicType.powerState:
            
            hkAccessoryPowerState = value as? Bool ?? hkAccessoryPowerState
            
        case CharacteristicType.brightness:
            
            hkAccessoryBrightness = value as? Int ?? hkAccessoryBrightness
            
        default:
            Debugger.shared.log(debugLevel: .Warning, "Unhandled characteristic change for accessory \(name)")
        }
    }
    
    
    // MARK: - PLC IO-Signal assignment
    
    var outputSignal:AnalogOutputSignal{
        plc.signal(ioSymbol:instanceName) as! AnalogOutputSignal
    }
    
    
    // MARK: - PLC Parameter assignment
    
    public func assignInputParameters(){
        
        if characteristicChanged{
            powerState = hkAccessoryPowerState
            brightness = hkAccessoryBrightness
        }
        
        characteristicChanged.reset()
    }
    
    public func assignOutputParameters(){
        outputSignal.scaledValue = Float(brightness)
    }
    
    
    // MARK: - PLC Processing
    
    private let switchOffLevelDimmer:Int = 15
    private var previousbrightness:Int = 0
        
    var powerState:Bool = false{
        didSet{
            if powerState != oldValue{
                brightness = powerState ? previousbrightness : 0
            }
        }
    }
    
    var brightness:Int = 0{
        didSet{
            if brightness != oldValue{
                // When swicthed on, remember each new brightnesslevel,
                // to be used as a startlevel later on
                if brightness > switchOffLevelDimmer{
                    previousbrightness = brightness
                }
            }
        }
    }
    
    
}

