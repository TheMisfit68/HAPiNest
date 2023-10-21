//
//  PLCConfiguration.swift
//  HAPiNest
//
//  Created by Jan Verrept on 15/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import SoftPLC
import ModbusDriver


extension MainConfiguration{
    
    struct PLC{
        
        static var HardwareConfig:SoftPLC.HardwareConfiguration = [
            
            0:[
                IOLogicE1241(ipAddress: "192.168.0.150"),
                IOLogicE1210(ipAddress: "192.168.0.151"),
                IOLogicE1210(ipAddress: "192.168.0.152"),
                IOLogicE1210(ipAddress: "192.168.0.153"),
                IOLogicE1211(ipAddress: "192.168.0.154"),
                IOLogicE1211(ipAddress: "192.168.0.155"),
                IOLogicE1211(ipAddress: "192.168.0.156"),
            ]
            
        ]
        
        static var IOList:SoftPLC.IOList{
            
            // Prepare a multideminsional array of optional String of the correct size
            let NumberOfRacks = 1
            let MaxNumberOfModulesPerRack = 7
            let MaxNumberOfChannelsPerModule = 16
            
            let Channels:[SoftPLC.IOSymbol?] = Array(repeating: nil, count: MaxNumberOfChannelsPerModule)
            let Modules:[[SoftPLC.IOSymbol?]] = Array(repeating: Channels, count: MaxNumberOfModulesPerRack)
            var IOList:[[[SoftPLC.IOSymbol?]]] = Array(repeating: Modules, count: NumberOfRacks)
            
            // Analog Output 0
            // Dimmable lights
            IOList[0][0][0] = .setpoint(circuit: String(localized: "Bathroom Mood Lights", table:"AccessoryNames"))
            IOList[0][0][1] = .setpoint(circuit: String(localized: "Bedroom Light", table:"AccessoryNames"))
            IOList[0][0][2] =  nil
            IOList[0][0][3] =  nil
            
            // Digital inputs 1...3
            // Lights
            IOList[0][1][0] = .feedbackEnabled(circuit: String(localized: "Twilight Sensor Enable", table:"AccessoryNames"))
            IOList[0][1][1] = .feedbackEnabled(circuit: String(localized: "Landing Light Enable", table:"AccessoryNames"))
            IOList[0][1][2] = .feedbackOn(circuit: String(localized: "Bathroom Light", table:"AccessoryNames"))
            IOList[0][1][3] = .feedbackOn(circuit: String(localized: "Bathroom mirror Light", table:"AccessoryNames"))
            IOList[0][1][4] = .feedbackOn(circuit: String(localized: "Basement Light", table:"AccessoryNames"))
            IOList[0][1][5] = .feedbackOn(circuit: String(localized: "Garage Light", table:"AccessoryNames"))
            IOList[0][1][6] = .feedbackOn(circuit: String(localized: "Garage workbench Light", table:"AccessoryNames"))
            IOList[0][1][7] = .feedbackOn(circuit: String(localized: "Kitchen Light", table:"AccessoryNames"))
            IOList[0][1][8] = .feedbackOn(circuit: String(localized: "Kitchen cabinet Light", table:"AccessoryNames"))
            IOList[0][1][9] = .feedbackOn(circuit: String(localized: "Office Light", table:"AccessoryNames"))
            IOList[0][1][10] = .feedbackOn(circuit: String(localized: "Dining room Light", table:"AccessoryNames"))
            IOList[0][1][11] = .feedbackOn(circuit: String(localized: "Dressing room Light", table:"AccessoryNames"))
            IOList[0][1][12] = .feedbackOn(circuit: String(localized: "Outside Light", table:"AccessoryNames"))
            IOList[0][1][13] = .feedbackOn(circuit: String(localized: "Landing Light", table:"AccessoryNames"))
            IOList[0][1][14] = .feedbackOn(circuit: String(localized: "Hallway Light", table:"AccessoryNames"))
            IOList[0][1][15] = .feedbackOn(circuit: String(localized: "Toilet Light", table:"AccessoryNames"))
            
            // Window Coverings feedback opening
            IOList[0][2][0] = .feedbackOpening(circuit:String(localized: "Kitchen Screens", table:"AccessoryNames"))
            IOList[0][2][1] = .feedbackOpening(circuit:String(localized: "Living room Screens", table:"AccessoryNames"))
            IOList[0][2][2] = .feedbackOpening(circuit:String(localized: "Bedroom Screen", table:"AccessoryNames"))
            IOList[0][2][3] = .feedbackOpening(circuit:String(localized: "Loft Screen", table:"AccessoryNames"))
            IOList[0][2][4] = .feedbackOpening(circuit:String(localized: "Kitchen Blinds", table:"AccessoryNames"))
            IOList[0][2][5] = .feedbackOpening(circuit:String(localized: "Living room Blinds", table:"AccessoryNames"))
            IOList[0][2][6] = .feedbackClosing(circuit:String(localized: "Bedroom Blinds", table:"AccessoryNames")) // This wires of this motor are connected reveresed
            IOList[0][2][7] = .feedbackOpening(circuit:String(localized: "Loft Blinds", table:"AccessoryNames"))
            IOList[0][2][8] = .feedbackOpening(circuit:String(localized: "Landing Blinds", table:"AccessoryNames"))
            
            // Varia
            IOList[0][2][9] = .feedbackOn(circuit:String(localized: "Basement Compressor", table:"AccessoryNames"))
            IOList[0][2][10] = nil
            IOList[0][2][11] = nil
            IOList[0][2][12] = nil
            IOList[0][2][13] = nil
            IOList[0][2][14] = nil
            IOList[0][2][15] = nil
            
            // Window Coverings feedback Down
            IOList[0][3][0] = .feedbackClosing(circuit:String(localized: "Kitchen Screens", table:"AccessoryNames"))
            IOList[0][3][1] = .feedbackClosing(circuit:String(localized: "Living room Screens", table:"AccessoryNames"))
            IOList[0][3][2] = .feedbackClosing(circuit:String(localized: "Bedroom Screen", table:"AccessoryNames"))
            IOList[0][3][3] = .feedbackClosing(circuit:String(localized: "Loft Screen", table:"AccessoryNames"))
            IOList[0][3][4] = .feedbackClosing(circuit:String(localized: "Kitchen Blinds", table:"AccessoryNames"))
            IOList[0][3][5] = .feedbackClosing(circuit:String(localized: "Living room Blinds", table:"AccessoryNames"))
            IOList[0][3][6] = .feedbackOpening(circuit:String(localized: "Bedroom Blinds", table:"AccessoryNames")) // This wires of this motor are connected reveresed
            IOList[0][3][7] = .feedbackClosing(circuit:String(localized: "Loft Blinds", table:"AccessoryNames"))
            IOList[0][3][8] = .feedbackClosing(circuit:String(localized: "Landing Blinds", table:"AccessoryNames"))
            IOList[0][3][9] =  nil
            IOList[0][3][10] = nil
            IOList[0][3][11] = nil
            IOList[0][3][12] = .functionKey(circuit:String(localized: "Hallway front door", table:"AccessoryNames"))
            IOList[0][3][13] = .functionKey(circuit:String(localized: "Bedroom bed left side", table:"AccessoryNames"))
            IOList[0][3][14] = .functionKey(circuit:String(localized: "Bedroom bed right side", table:"AccessoryNames"))
            IOList[0][3][15] = .functionKey(circuit:String(localized: "Landing area", table:"AccessoryNames"))
            
            // Digital outputs 4...6
            // Lights
            IOList[0][4][0] = .enable(circuit:String(localized: "Twilight Sensor Enable", table:"AccessoryNames"))
            IOList[0][4][1] = .enable(circuit:String(localized: "Landing Light Enable", table:"AccessoryNames"))
            IOList[0][4][2] = .toggle(circuit:String(localized: "Bathroom Light", table:"AccessoryNames"))
            IOList[0][4][3] = .toggle(circuit:String(localized: "Bathroom mirror Light", table:"AccessoryNames"))
            IOList[0][4][4] = .toggle(circuit:String(localized: "Basement Light", table:"AccessoryNames"))
            IOList[0][4][5] = .toggle(circuit:String(localized: "Garage Light", table:"AccessoryNames"))
            IOList[0][4][6] = .toggle(circuit:String(localized: "Garage workbench Light", table:"AccessoryNames"))
            IOList[0][4][7] = .toggle(circuit:String(localized: "Kitchen Light", table:"AccessoryNames"))
            IOList[0][4][8] = .toggle(circuit:String(localized: "Kitchen cabinet Light", table:"AccessoryNames"))
            IOList[0][4][9] = .toggle(circuit:String(localized: "Office Light", table:"AccessoryNames"))
            IOList[0][4][10] = .toggle(circuit:String(localized: "Dining room Light", table:"AccessoryNames"))
            IOList[0][4][11] = .toggle(circuit:String(localized: "Dressing room Light", table:"AccessoryNames"))
            IOList[0][4][12] = nil
            IOList[0][4][13] = .toggle(circuit:String(localized: "Landing Light", table:"AccessoryNames"))
            IOList[0][4][14] = .toggle(circuit:String(localized: "Hallway Light", table:"AccessoryNames"))
            IOList[0][4][15] = .toggle(circuit:String(localized: "Toilet Light", table:"AccessoryNames"))
            
            // Window Coverings
            IOList[0][5][0] = .toggle(circuit:String(localized: "Kitchen Screens", table:"AccessoryNames"))
            IOList[0][5][1] = .toggle(circuit:String(localized: "Living room Screens", table:"AccessoryNames"))
            IOList[0][5][2] = .toggle(circuit:String(localized: "Bedroom Screen", table:"AccessoryNames"))
            IOList[0][5][3] = .toggle(circuit:String(localized: "Loft Screen", table:"AccessoryNames"))
            IOList[0][5][4] = .toggle(circuit:String(localized: "Kitchen Blinds", table:"AccessoryNames"))
            IOList[0][5][5] = .toggle(circuit:String(localized: "Living room Blinds", table:"AccessoryNames"))
            IOList[0][5][6] = .toggle(circuit:String(localized: "Bedroom Blinds", table:"AccessoryNames"))
            IOList[0][5][7] = .toggle(circuit:String(localized: "Loft Blinds", table:"AccessoryNames"))
            IOList[0][5][8] = .toggle(circuit:String(localized: "Landing Blinds", table:"AccessoryNames"))
            
            // Varia
            IOList[0][5][9] = .toggle(circuit:String(localized: "Basement Compressor", table:"AccessoryNames"))
            IOList[0][5][10] =  nil
            IOList[0][5][11] =  nil
            IOList[0][5][12] =  nil
            IOList[0][5][13] =  nil
            IOList[0][5][14] =  nil
            IOList[0][5][15] =  nil
            
            // Outlets
            IOList[0][6][0] = .on(circuit:String(localized: "Outdoor Power Outlet", table:"AccessoryNames"))
            IOList[0][6][1] = .on(circuit:String(localized: "Garage Dryer", table:"AccessoryNames"))
            IOList[0][6][2] = .on(circuit:String(localized: "Garage Ventilation", table:"AccessoryNames"))
            IOList[0][6][3] = .on(circuit:String(localized: "Kitchen Powerport", table:"AccessoryNames"))
            IOList[0][6][4] = .on(circuit:String(localized: "Living room Power Outlet", table:"AccessoryNames"))
            IOList[0][6][5] = .on(circuit:String(localized: "Dining room Power Outlet", table:"AccessoryNames"))
            IOList[0][6][6] = .on(circuit:String(localized: "Office Power Outlet whiteboard", table:"AccessoryNames"))
            IOList[0][6][7] = .on(circuit:String(localized: "Office Power Outlet", table:"AccessoryNames"))
            IOList[0][6][8] = .on(circuit:String(localized: "Hallway Power Outlet", table:"AccessoryNames"))
            IOList[0][6][9] = .on(circuit:String(localized: "Bedroom Power Outlet bed right side", table:"AccessoryNames"))
            IOList[0][6][10] = .on(circuit:String(localized: "Bedroom Power Outlet bed left side", table:"AccessoryNames"))
            IOList[0][6][11] = .on(circuit:String(localized: "Bedroom Power Outlet TV", table:"AccessoryNames"))
            IOList[0][6][12] = .on(circuit:String(localized: "Landing Power Outlet", table:"AccessoryNames"))
            IOList[0][6][13] = .on(circuit:String(localized: "Front Door", table:"AccessoryNames"))
            IOList[0][6][14] = .toggle(circuit:String(localized: "Garage Door", table:"AccessoryNames"))
            IOList[0][6][15] = .enable(circuit:String(localized: "Smart Sprinklers", table:"AccessoryNames"))
            
            return IOList
        }
        
        static var PLCobjects:[String:PLCClass] = [
            
            String(localized:"Twilight Sensor Enable", table:"AccessoryNames") : CirtcuitEnabler(),
            String(localized:"Landing Light Enable", table:"AccessoryNames") : CirtcuitEnabler(),
            
            // Function keys / Switches
            //            String(localized:"Hal Functietoets Voordeur", table:"AccessoryNames") : Switch(),
            //            String(localized:"SlaapKamer Functietoets Bed Anja", table:"AccessoryNames") : Switch(),
            //            String(localized:"SlaapKamer Functietoets Bed Jan", table:"AccessoryNames") : Switch(),
            //            String(localized:"Overloop Functietoets", table:"AccessoryNames") : Switch(),
            
            // Dimmable lights
            String(localized:"Bathroom Mood Lights", table:"AccessoryNames") : DimmableLight(),
            String(localized:"Bedroom Light", table:"AccessoryNames") : DimmableLight(),
            
            // Lights
            String(localized:"Bathroom Light", table:"AccessoryNames") : Light(),
            String(localized:"Bathroom mirror Light", table:"AccessoryNames") : Light(),
            String(localized:"Basement Light", table:"AccessoryNames") : Light(),
            String(localized:"Garage Light", table:"AccessoryNames") : Light(),
            String(localized:"Garage workbench Light", table:"AccessoryNames") : Light(),
            String(localized:"Kitchen cabinet Light", table:"AccessoryNames") : Light(),
            String(localized:"Kitchen Light", table:"AccessoryNames") : Light(),
            String(localized:"Office Light", table:"AccessoryNames") : Light(),
            String(localized:"Dining room Light", table:"AccessoryNames") : Light(),
            String(localized:"Dressing room Light", table:"AccessoryNames") : Light(),
            
            String(localized:"Landing Light", table:"AccessoryNames") : Light(),
            String(localized:"Hallway Light", table:"AccessoryNames") : Light(),
            String(localized:"Toilet Light", table:"AccessoryNames") : Light(),
            
            // Window Coverings
            String(localized:"Kitchen Screens", table:"AccessoryNames") : WindowCovering(secondsToOpen: 35, secondsToClose: 35),
            String(localized:"Living room Screens", table:"AccessoryNames") : WindowCovering(secondsToOpen: 50, secondsToClose: 50),
            String(localized:"Bedroom Screen", table:"AccessoryNames") : WindowCovering(secondsToOpen: 50, secondsToClose: 50),
            String(localized:"Loft Screen", table:"AccessoryNames") : WindowCovering(secondsToOpen: 35, secondsToClose: 35),
            String(localized:"Kitchen Blinds", table:"AccessoryNames") : WindowCovering(secondsToOpen: 30, secondsToClose: 30),
            String(localized:"Living room Blinds", table:"AccessoryNames") : WindowCovering(secondsToOpen: 30, secondsToClose: 30),
            String(localized:"Bedroom Blinds", table:"AccessoryNames") : WindowCovering(secondsToOpen: 25, secondsToClose: 25),
            String(localized:"Loft Blinds", table:"AccessoryNames") : WindowCovering(secondsToOpen: 25, secondsToClose: 25),
            String(localized:"Landing Blinds", table:"AccessoryNames") : WindowCovering(),
            
            // Varia
            String(localized:"Basement Compressor", table:"AccessoryNames") : ToggleableOutlet(),
            
            // Outlets
            String(localized:"Outdoor Power Outlet", table:"AccessoryNames") : Outlet(),
            String(localized:"Garage Dryer", table:"AccessoryNames") : Outlet(defaultPowerState: true),
            String(localized:"Garage Ventilation", table:"AccessoryNames") : Outlet(defaultPowerState: true),
            String(localized:"Kitchen Powerport", table:"AccessoryNames") : Outlet(defaultPowerState: true),
            String(localized:"Living room Power Outlet", table:"AccessoryNames") : Outlet(),
            String(localized:"Dining room Power Outlet", table:"AccessoryNames") : Outlet(),
            String(localized:"Office Power Outlet whiteboard", table:"AccessoryNames") : Outlet(),
            String(localized:"Office Power Outlet", table:"AccessoryNames") : Outlet(),
            String(localized:"Hallway Power Outlet", table:"AccessoryNames") : Outlet(),
            String(localized:"Bedroom Power Outlet bed right side", table:"AccessoryNames") : Outlet(),
            String(localized:"Bedroom Power Outlet bed left side", table:"AccessoryNames") : Outlet(),
            String(localized:"Bedroom Power Outlet TV", table:"AccessoryNames") : Outlet(defaultPowerState: true),
            String(localized:"Landing Power Outlet", table:"AccessoryNames") : Outlet(),
            
            // Varia
            String(localized:"Front Door", table:"AccessoryNames") : Doorlock(),
            String(localized:"Garage Door", table:"AccessoryNames") : GarageDoor(),
            String(localized:"Smart Sprinklers", table:"AccessoryNames") : SmartSprinkler(),
        ]
    }
    
}
