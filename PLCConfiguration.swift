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
            
            let Channels:[String?] = Array(repeating: nil, count: MaxNumberOfChannelsPerModule)
            let Modules = Array(repeating: Channels, count: MaxNumberOfModulesPerRack)
            var IOList = Array(repeating: Modules, count: NumberOfRacks)
            
            // Analog Output 0
            // Dimmable lights
            IOList[0][0][0] = String(localized: "Bathroom Mood Lights", table:"SignalNames")
            IOList[0][0][1] = String(localized: "Bedroom Lights", table:"SignalNames")
            IOList[0][0][2] =  nil
            IOList[0][0][3] =  nil
            
            // Digital inputs 1...3
            // Lights
            IOList[0][1][0] = String(localized: "Twilight Sensor Enabled", table:"SignalNames")
            IOList[0][1][1] = String(localized: "Landing Light Enabled", table:"SignalNames")
            IOList[0][1][2] = String(localized: "Bathroom Light On", table:"SignalNames")
            IOList[0][1][3] = String(localized: "Bathroom mirror Light On", table:"SignalNames")
            IOList[0][1][4] = String(localized: "Basement Light On", table:"SignalNames")
            IOList[0][1][5] = String(localized: "Garage Light On", table:"SignalNames")
            IOList[0][1][6] = String(localized: "Garage workbench Licht On", table:"SignalNames")
            IOList[0][1][7] = String(localized: "Kitchen Light On", table:"SignalNames")
            IOList[0][1][8] = String(localized: "Kitchen cabinet Light On", table:"SignalNames")
            IOList[0][1][9] = String(localized: "Office Light On", table:"SignalNames")
            IOList[0][1][10] = String(localized: "Dining Room Light On", table:"SignalNames")
            IOList[0][1][11] = String(localized: "Dressing Room Light On", table:"SignalNames")
            IOList[0][1][12] = String(localized: "Buiten Licht On", table:"SignalNames")
            IOList[0][1][13] = String(localized: "Landing Light On", table:"SignalNames")
            IOList[0][1][14] = String(localized: "Hallway Light", table:"SignalNames")
            IOList[0][1][15] = String(localized: "Toilet Light On", table:"SignalNames")
            
            // Window Coverings feedback Up
            IOList[0][2][0] = String(localized: "Kitchen Screens Open", table:"SignalNames")
            IOList[0][2][1] = String(localized: "Living Room Screens Open", table:"SignalNames")
            IOList[0][2][2] = String(localized: "Bedroom Screen Open", table:"SignalNames")
            IOList[0][2][3] = String(localized: "Loft Screen Open", table:"SignalNames")
            IOList[0][2][4] = String(localized: "Kitchen Blinds Open", table:"SignalNames")
            IOList[0][2][5] = String(localized: "Living Room Blinds Open", table:"SignalNames")
            IOList[0][2][6] = String(localized: "Bedroom Blinds Close", table:"SignalNames") // This wires of this motor are connected reveresed
            IOList[0][2][7] = String(localized: "Loft Blinds Open", table:"SignalNames")
            IOList[0][2][8] = String(localized: "Landing Blinds Open", table:"SignalNames")
			
			// Varia
            IOList[0][2][9] = String(localized: "Basement Compressor On", table:"SignalNames")
            IOList[0][2][10] =  nil
            IOList[0][2][11] =  nil
            IOList[0][2][12] =  nil
            IOList[0][2][13] =  nil
            IOList[0][2][14] =  nil
            IOList[0][2][15] =  nil
            
            // Window Coverings feedback Down
            IOList[0][3][0] = String(localized: "Kitchen Screens Close", table:"SignalNames")
            IOList[0][3][1] = String(localized: "Living Room Screens Close", table:"SignalNames")
            IOList[0][3][2] = String(localized: "Bedroom Screen Close", table:"SignalNames")
            IOList[0][3][3] = String(localized: "Loft Screen Close", table:"SignalNames")
            IOList[0][3][4] = String(localized: "Kitchen Blinds Close", table:"SignalNames")
            IOList[0][3][5] = String(localized: "Living Room Blinds Close", table:"SignalNames")
            IOList[0][3][6] = String(localized: "Bedroom Blinds Open", table:"SignalNames") // This wires of this motor are connected reveresed
            IOList[0][3][7] = String(localized: "Loft Blinds Close", table:"SignalNames")
            IOList[0][3][8] = String(localized: "Landing Blinds Close", table:"SignalNames")
            IOList[0][3][9] =  nil
            IOList[0][3][10] =  nil
            IOList[0][3][11] =  nil
            IOList[0][3][12] = String(localized: "Hallway Function Key front door", table:"SignalNames")
            IOList[0][3][13] = String(localized: "Bedroom Function Key bed left side", table:"SignalNames")
            IOList[0][3][14] = String(localized: "Bedroom Function Key bed right side", table:"SignalNames")
            IOList[0][3][15] = String(localized: "Landing Function Key", table:"SignalNames")
            
            // Digital outputs 4...6
            // Lights
            IOList[0][4][0] = String(localized: "Twilight Sensor Enable", table:"SignalNames")
            IOList[0][4][1] = String(localized: "Landing Light Enable", table:"SignalNames")
            IOList[0][4][2] = String(localized: "Bathroom Light", table:"SignalNames")
            IOList[0][4][3] = String(localized: "Bathroom mirror Light", table:"SignalNames")
            IOList[0][4][4] = String(localized: "Basement Light", table:"SignalNames")
            IOList[0][4][5] = String(localized: "Garage Light", table:"SignalNames")
            IOList[0][4][6] = String(localized: "Garage workbench Light", table:"SignalNames")
            IOList[0][4][7] = String(localized: "Kitchen Light", table:"SignalNames")
            IOList[0][4][8] = String(localized: "Kitchen cabinet Light", table:"SignalNames")
            IOList[0][4][9] = String(localized: "Office Light", table:"SignalNames")
            IOList[0][4][10] = String(localized: "Dining Room Light", table:"SignalNames")
            IOList[0][4][11] = String(localized: "Dressing Room Light", table:"SignalNames")
            IOList[0][4][12] =  nil
            IOList[0][4][13] = String(localized: "Landing Light", table:"SignalNames")
            IOList[0][4][14] = String(localized: "Hallway Light", table:"SignalNames")
            IOList[0][4][15] = String(localized: "Toilet Light", table:"SignalNames")
            
            // Window Coverings
            IOList[0][5][0] = String(localized: "Kitchen Screens", table:"SignalNames")
            IOList[0][5][1] = String(localized: "Living Room Screens", table:"SignalNames")
            IOList[0][5][2] = String(localized: "Bedroom Screen", table:"SignalNames")
            IOList[0][5][3] = String(localized: "Loft Screen", table:"SignalNames")
            IOList[0][5][4] = String(localized: "Kitchen Blinds", table:"SignalNames")
            IOList[0][5][5] = String(localized: "Living Room Blinds", table:"SignalNames")
            IOList[0][5][6] = String(localized: "Bedroom Blinds", table:"SignalNames")
            IOList[0][5][7] = String(localized: "Loft Blinds", table:"SignalNames")
            IOList[0][5][8] = String(localized: "Landing Blinds", table:"SignalNames")
            
            // Varia
            IOList[0][5][9] = String(localized: "Basement Compressor", table:"SignalNames")
            IOList[0][5][10] =  nil
            IOList[0][5][11] =  nil
            IOList[0][5][12] =  nil
            IOList[0][5][13] =  nil
            IOList[0][5][14] =  nil
            IOList[0][5][15] =  nil
            
            // Outlets
            IOList[0][6][0] = String(localized: "Outdoor Power Outlet", table:"SignalNames")
            IOList[0][6][1] = String(localized: "Garage Dryer", table:"SignalNames")
            IOList[0][6][2] = String(localized: "Garage Ventilation", table:"SignalNames")
            IOList[0][6][3] = String(localized: "Kitchen Powerport", table:"SignalNames")
            IOList[0][6][4] = String(localized: "Living Room Power Outlet", table:"SignalNames")
            IOList[0][6][5] = String(localized: "Dining Room Power Outlet", table:"SignalNames")
            IOList[0][6][6] = String(localized: "Office Power Outlet whiteboard", table:"SignalNames")
            IOList[0][6][7] = String(localized: "Office Power Outlet", table:"SignalNames")
            IOList[0][6][8] = String(localized: "Hallway Power Outlet", table:"SignalNames")
            IOList[0][6][9] = String(localized: "Bedroom Power Outlet bed right side", table:"SignalNames")
            IOList[0][6][10] = String(localized: "Bedroom Power Outlet bed left side", table:"SignalNames")
            IOList[0][6][11] = String(localized: "Bedroom Power Outlet TV", table:"SignalNames")
            IOList[0][6][12] = String(localized: "Landing Power Outlet", table:"SignalNames")
            IOList[0][6][13] = String(localized: "Front Door", table:"SignalNames")
            IOList[0][6][14] = String(localized: "Garage Door", table:"SignalNames")
            IOList[0][6][15] = String(localized: "Smart Sprinklers", table:"SignalNames")
            
            return IOList
        }
        
        static var PLCobjects:[String:PLCClass] = [
            
            String(localized:"Twilight Sensor Enable", table:"AccessoryNames") : Light(),
			String(localized:"Landing Light Enable", table:"AccessoryNames") : Light(),

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
            String(localized:"Dining Room Light", table:"AccessoryNames") : Light(),
            String(localized:"Dressing Room Light", table:"AccessoryNames") : Light(),
			
            String(localized:"Landing Light", table:"AccessoryNames") : Light(),
            String(localized:"Hallway Light", table:"AccessoryNames") : Light(),
            String(localized:"Toilet Light", table:"AccessoryNames") : Light(),
            
            // Window Coverings
            String(localized:"Kitchen Screens", table:"AccessoryNames") : WindowCovering(secondsToOpen: 35, secondsToClose: 35),
            String(localized:"Living Room Screens", table:"AccessoryNames") : WindowCovering(secondsToOpen: 50, secondsToClose: 50),
            String(localized:"Bedroom Screen", table:"AccessoryNames") : WindowCovering(secondsToOpen: 50, secondsToClose: 50),
            String(localized:"Loft Screen", table:"AccessoryNames") : WindowCovering(secondsToOpen: 35, secondsToClose: 35),
            String(localized:"Kitchen Blinds", table:"AccessoryNames") : WindowCovering(secondsToOpen: 30, secondsToClose: 30),
            String(localized:"Living Room Blinds", table:"AccessoryNames") : WindowCovering(secondsToOpen: 30, secondsToClose: 30),
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
            String(localized:"Living Room Power Outlet", table:"AccessoryNames") : Outlet(),
            String(localized:"Dining Room Power Outlet", table:"AccessoryNames") : Outlet(),
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
