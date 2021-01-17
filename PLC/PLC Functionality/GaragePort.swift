//
//  GaragePort.swift
//  HAPiNest
//
//  Created by Jan Verrept on 23/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Cocoa
import HAP
import SoftPLC
import ModbusDriver
import JVCocoa

//class GaragePort:PLCclass, AccessoryDelegate, AccessorySource, PulsOperatedCircuit{
//    func handleCharacteristicChange<T>(accessory: Accessory, service: Service, characteristic: GenericCharacteristic<T>, to value: T?) where T : CharacteristicValueType {
//        <#code#>
//    }
//
//    typealias AccessorySubclass = <#type#>
//
//    typealias DigitalTimerType = <#type#>
//
    
//    // MARK: - HomeKit Accessory binding
//    typealias AccessoryType = Accessory.GarageDoorOpener
//    
//    func handleCharacteristicChange<T>(accessory:Accessory,
//                                       service: Service,
//                                       characteristic: GenericCharacteristic<T>,
//                                       to value: T?){
//    }
//    
//    var hkAccessoryTargetDoorState:Bool{
//        get{
//            accessory?
//        }
//        set{
//            accessory?.switch.powerState.value = newValue
//        }
//    }
//
//    var hkAccessoryCurrentDoorState:Enums.CurrentBasicGarageDoorState{
//        get{
//            accessory?.service.currentState.value ?? .stopped
//        }
//        set{
//            accessory?.service.currentState.value = newValue
//        }
//    }
//
//    var enableHkfeedback:Bool{
//        // Only when circuit is idle
//        // send the feedback upstream to the Homekit accessory
//        // provides for a more stable feedback
//        !hkTargetDoorStateChanged && !feedbackChanged && !puls
//    }
//
//    // MARK: - PLC IO-Signal assignment
//
//    var outputSignal:DigitalOutputSignal{
//        plc.signal(ioSymbol:instanceName) as! DigitalOutputSignal
//    }
//
//
//    // MARK: - PLC parameter assignment
//
//    public func assignInputParameters(){
//
//        hkTargetDoorState = hkAccessoryTargetDoorState
//        hkCurrentDoorState = hkAccessoryCurrentDoorState
//
//        if !inited{ // Optineel te vewijderen eerst in commentaar
//
//            openedTimer.action = {
//                self.feedback = .open
//                self.hkAccessoryCurrentDoorState = self.feedback // Optineel te vewijderen eerst in commentaar
//            }
//            closedTimer.action = {
//                self.feedback = .closed
//                self.hkAccessoryCurrentDoorState = self.feedback // Optineel te vewijderen eerst in commentaar
//            }
//
//            hkAccessoryTargetDoorState = targetDoorState
//            hkAccessoryCurrentDoorState = feedback
//            inited = true
//
//
//        }else if hkTargetDoorStateChanged{
//            targetDoorState = hkAccessoryTargetDoorState
//            feedback = hkAccessoryCurrentDoorState
//            print("***** IN\tTarget \(hkTargetDoorState)\tCurrent \(feedback)")
//        }else if hkCurrentDoorStateChanged{
//            hkAccessoryCurrentDoorState = feedback
//        }else if feedbackChanged{
//            hkAccessoryCurrentDoorState = feedback
//        }
//
//
//    }
//
//    public func assignOutputParameters(){
//        outputSignal.logicalValue = puls
//
//        print("***** OUT\tTarget \(hkTargetDoorState)\tCurrent \(feedback)")
//        hkAccessoryCurrentDoorState = feedback
//    }
//
//
//    // MARK: - Observing changes
//
//    private var hkTargetDoorStateChanged:Bool = false
//    private var hkCurrentDoorStateChanged:Bool = false
//    private var feedbackChanged:Bool = false
//
//    var hkTargetDoorState:Enums.TargetDoorState = .closed{
//        didSet{
//            hkTargetDoorStateChanged = (hkTargetDoorState != oldValue)
//        }
//    }
//
//    var hkCurrentDoorState:Enums.CurrentDoorState = .closed{
//        didSet{
//            hkCurrentDoorStateChanged = (hkCurrentDoorState != oldValue)
//        }
//    }
//
//    var feedback:Enums.CurrentDoorState = .closed{
//        didSet{
//            feedbackChanged = (feedback != oldValue)
//
//            openedTimer.input =  (feedback == .opening)
//            closedTimer.input = (feedback == .closing)
//        }
//
//    }
//
//
//    // MARK: - Parse State
//
//    private var targetDoorState:Enums.TargetDoorState = .closed
//    private var nextCurrentDoorState:Enums.CurrentDoorState{
//
//        switch feedback {
//        case .closed:
//            return .opening
//        case .open:
//            return .closing
//        case .opening, .closing:
//            return .stopped
//        case .stopped:
//
//            switch hkTargetDoorState {
//            case .open:
//                return .opening
//            case .closed:
//                return .closing
//            }
//        }
//
//    }
//
//
//    // MARK: - Parse State
//
//    override init(){
//
//        super.init()
//
//    }
//
//
//    var inited:Bool = false
//
//    var openedTimer = DigitalTimer.OnDelay(time: 21.0)
//    var closedTimer = DigitalTimer.OnDelay(time: 25.0)
//    let pulsTimer = DigitalTimer.ExactPuls(time: 1.0)
//
//    var puls:Bool{
//
//        get{
//            let opening = (feedback == .opening) || (feedback == .open)
//            let closing = (feedback == .closing) || (feedback == .closed)
//            let pulsInput = ((targetDoorState == .open) && !opening) || ((targetDoorState == .closed) && !closing)
//            pulsTimer.input = pulsInput
//
//            if pulsInput{
//                feedback = nextCurrentDoorState // With each new puls provide the next (simulated) state as feedback
//            }
//
//            return pulsTimer.output
//        }
//
//    }
//    
//}

