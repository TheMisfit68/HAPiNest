//
//  FunctionKey.swift
//  HAPiNest
//
//  Created by Jan Verrept on 31/12/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation

import Cocoa
import HAP
import SoftPLC
import ModbusDriver
import IOTypes
import JVCocoa

class FunctionKey:PLCClass, Parameterizable, CyclicRunnable{
    
    let shorcutDriver:ShortcutsDriver

    private var inputPuls:Bool = false
    private var inputTriggered:EBool
    
    var clicked:Bool = false{
        didSet{
            if clicked{
                try? shorcutDriver.run("HomekitScene",withParameter: clickedScene)
            }
            clicked.reset()
        }
    }
    let clickedScene:String
    
    let doubleclikInterval:TimeInterval
    let doubleClickTimer:DigitalTimer
    var doubleClicked:Bool = false{
        didSet{
            if doubleClicked, let sceneToRun = doubleClickedScene{
                try? shorcutDriver.run("HomekitScene",withParameter: sceneToRun)
            }
            doubleClicked.reset()
        }
    }
    let doubleClickedScene:String?
    
    let longPressTime:TimeInterval
    let longPressTimer:DigitalTimer
    var longPressed:Bool = false{
        didSet{
            if longPressed, let sceneToRun = longPressScene{
                try? shorcutDriver.run("HomekitScene",withParameter: sceneToRun)
            }
            longPressed.reset()
        }
    }
    let longPressScene:String?
    

    init(clicked:String, doubleClicked:String?, longPress:String?){
        
        self.shorcutDriver = ShortcutsDriver()
        
        self.inputTriggered = EBool(&inputPuls)
        
        self.clickedScene = clicked
        
        self.doubleclikInterval = 1.0
        self.doubleClickTimer = DigitalTimer.OffDelay(time: doubleclikInterval)
        self.doubleClickedScene = doubleClicked
        
        self.longPressTime = 2.0
        self.longPressTimer = DigitalTimer.OnDelay(time: longPressTime)
        self.longPressScene = longPress
        
        super.init()
    }
    
    var inputSignal:DigitalInputSignal{
        let ioSymbol:SoftPLC.IOSymbol = .functionKey(circuit:String(localized: "\(instanceName)", table:"AccessoryNames"))
        return plc.signal(ioSymbol:ioSymbol) as! DigitalInputSignal
    }
    
    public func assignInputParameters(){
        
        if let hardwarePuls = inputSignal.logicalValue{
            inputPuls = hardwarePuls
        }else{
            inputPuls = false
        }
        
    }
    
    public func assignOutputParameters(){
        // Function keys have no outputs associated with them!
    }
    
    // MARK: - PLC Processing
    public func runCycle() {
        
        let risingEdge = inputTriggered.🔼
        
        if  risingEdge && !doubleClickTimer.output{
            clicked.set()
        }else if risingEdge && doubleClickTimer.output{
            doubleClicked.set()
        }else if longPressTimer.output{
            longPressed.set()
        }
        
        doubleClickTimer.input = inputPuls
        longPressTimer.input = inputPuls
        
    }
    
}
