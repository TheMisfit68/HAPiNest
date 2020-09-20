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

extension DimmableLight:Parameterizable{
    
    public func assignInputParameters(){
        
        if let hkState  = homekitParameters[.powerState] as? Bool{
            self.powerState = hkState ? .on : .off
        }
        if let hkBrightNess = homekitParameters[.brightness] as? Int{
            self.brightness = hkBrightNess
        }
        
    }
    
    public func assignOutputParameters(){
        
        if let ioSignal = plc.signal(ioSymbol:instanceName) as? AnalogOutputSignal{
            ioSignal.scaledValue = Float(brightness)
        }
    }
    
}


public class DimmableLight:PLCclass, HomekitControllable{
    
    var homekitParameters:[HomekitParameterName:Any] = [:]
    
    var ioSignal:AnalogOutputSignal? = nil
    
    public enum PowerState{
        case on
        case off
    }
    
    public var powerState:PowerState = .off{
        
        didSet{
            if powerState == .on{
                brightness = max(switchOffLevelDimmer+1, Int(previousBrightness))
            }else{
                brightness = 0
            }
        }
    }
    public var brightness:Int = 0{
        didSet{
            // When swicthed on, remember the brightnesslevel,
            // to be used as a startlevel later on
            if brightness > switchOffLevelDimmer{
                previousBrightness = brightness
            }
        }
    }
    private let switchOffLevelDimmer:Int = 15
    private var previousBrightness:Int = 0
}

