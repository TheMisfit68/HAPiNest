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

public class DimmableLight:PLCclass, HomekitControllable{
    
    var homeKitEvents:[CharacteristicType:Any] = [:]
    var homekitFeedbacks:[CharacteristicType:Any] = [:]
    
    private let switchOffLevelDimmer:Int = 15
    private var previousBrightness:Int = 0
    
    public enum PowerState{
        case on
        case off
    }
    
    public var powerState:PowerState = .off
    
    public var brightness:Int = 0{
        
        didSet{
            guard powerState == .on else {
                brightness = 0
                return
            }
            // When swicthed on, remember the brightnesslevel,
            // to be used as a startlevel later on
            if brightness > switchOffLevelDimmer{
                previousBrightness = brightness
            }
        }
    }
    
    internal func parseNewHomeKitEvents(){
        
        if let hkState  = homeKitEvents[.powerState] as? Bool{
            self.powerState = hkState ? .on : .off
        }
        if let hkBrightNess = homeKitEvents[.brightness] as? Int{
            self.brightness = hkBrightNess
        }
        
        homeKitEvents = [:]
    }
    
    public func assignInputParameters(){
        
        parseNewHomeKitEvents()
        
    }
    
    public func assignOutputParameters(){
        
        if let ioSignal = plc.signal(ioSymbol:instanceName) as? AnalogOutputSignal{
            ioSignal.scaledValue = Float(brightness)
        }
    }
    
}

