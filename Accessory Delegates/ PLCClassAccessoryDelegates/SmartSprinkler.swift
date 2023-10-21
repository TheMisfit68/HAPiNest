//
//  SmartSprinkler.swift
//  HAPiNest
//
//  Created by Jan Verrept on 17/01/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import Cocoa
import HAP
import SoftPLC
import ModbusDriver
import IOTypes
import JVCocoa
import WeatherKit
import CoreLocation
import OSLog

// MARK: - PLC level class
class SmartSprinkler:PLCClassAccessoryDelegate{
    
    // Accessory binding
    typealias AccessorySubclass = Accessory.SmartSprinkler
    var characteristicChanged:Bool = false
    
    // MARK: - State
    public var enabledState:Bool? = nil
    public var manualOnState:Bool? = nil
    public var programMode:Enums.ProgramMode = .programsScheduled // No way to determine this property for my 'dumb' irrigation system, so just always assume it is scheduled
    public var inUseState:Bool? = nil
    
    private let weatherReporter = WeatherReporter()
    private var needsIrrigation:Bool{
        let logger = Logger(subsystem: "be.oneclick.HAPiNest", category: "Smartsprinkler")
        logger.warning( "Drystate \(self.weatherReporter.wasDry)/\(self.weatherReporter.isDry)/\(self.weatherReporter.willBeDry)/\(self.weatherReporter.isWindy)")

        return (weatherReporter.wasDry && weatherReporter.isDry && weatherReporter.willBeDry && !weatherReporter.isWindy)
    }

    
    // Hardware feedback state
    private var hardwareInUseState:Bool?{
        didSet{
            hardwareFeedbackChanged.set( (hardwareInUseState != nil) && (oldValue != nil) &&  (hardwareInUseState != oldValue) )
        }
    }
    var hardwareFeedbackChanged:Bool = false
    
    
    
    // MARK: - IO-Signal assignment
    var outputSignal:DigitalOutputSignal{
        return plc.signal(ioSymbol:.enable(circuit:instanceName)) as! DigitalOutputSignal
    }
    
    
    // MARK: - Parameter assignment
    public func assignInputParameters(){
        
        outputSignal.outputLogic = .inverse
        hardwareInUseState = outputSignal.logicalFeedbackValue
        
    }
    
    public func assignOutputParameters(){
        
        outputSignal.logicalValue = inUseState ?? false
    }
    
    
    // MARK: - PLC Processing
    func runCycle() {
        
        Task{
            await weatherReporter.updateWeather()
        }
        
        // Evaluate Button-services
        // As a best effort, set the intialValue for the enable button to the latest value of the 'inUse' output
#warning("DEBUGPRINT") // TODO: - remove temp print statement
        print("🐞\t\(accessory.enableAutoService.powerState.value) \(accessory.manualOverrideService.powerState.value)")

        reevaluate(&enabledState, initialValue: hardwareInUseState,  characteristic:accessory.enableAutoService.enabled, hardwareFeedback: nil,
                   typeTranslators:({$0==Enums.Active.active}, {$0 ? Enums.Active.active : Enums.Active.inactive })
        )
        reevaluate(&manualOnState, initialValue: false,  characteristic:accessory.manualOverrideService.powerState, hardwareFeedback: nil)
        
        // Evaluate the Primary-Service (IrrigationSystem)
        reevaluate(&enabledState, initialValue: hardwareInUseState,  characteristic:accessory.primaryService.active, hardwareFeedback: nil,
                   typeTranslators:({$0==Enums.Active.active}, {$0 ? Enums.Active.active : Enums.Active.inactive })
        )
        inUseState = ( (enabledState ?? false) && needsIrrigation ) || (manualOnState  ?? false)
        reevaluate(&inUseState, characteristic:accessory.primaryService.inUse, hardwareFeedback: hardwareInUseState,
                   typeTranslators:({$0==Enums.InUse.inUse.rawValue}, {$0 ? Enums.InUse.inUse.rawValue : Enums.InUse.notInUse.rawValue})
        )
        
        characteristicChanged.reset()
        hardwareFeedbackChanged.reset()
    }
}
