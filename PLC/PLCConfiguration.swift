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
            IOList[0][0][0] = "Badkamer Sfeerlichtjes"
            IOList[0][0][1 ] = "Slaapkamer Licht"
            IOList[0][0][2] =  nil
            IOList[0][0][3] =  nil
            
            // Digital inputs 1...3
            // Lights
            IOList[0][1][0] =  "Buiten Licht Enabled"
            IOList[0][1][1] =  "Overloop Licht Enabled"
            IOList[0][1][2] =  "Badkamer Licht On"
            IOList[0][1][3] =  "Badkamer Licht spiegel On"
            IOList[0][1][4] =  "Kelder Licht On"
            IOList[0][1][5] =  "Garage Licht On"
            IOList[0][1][6] =  "Garage Licht Werkbank On"
            IOList[0][1][7] =  "Keuken Licht On"
            IOList[0][1][8] =  "Keuken Licht kast On"
            IOList[0][1][9] =  "Bureau Licht On"
            IOList[0][1][10] =  "Eetkamer Licht On"
            IOList[0][1][11] =  "Dressing Licht On"
            IOList[0][1][12] =  "Buiten Licht On"
            IOList[0][1][13] =  "Overloop Licht On"
            IOList[0][1][14] =  "Hal Licht On"
            IOList[0][1][15] =  "W.C. Licht On"
            
            // Window Coverings feedback Up
            IOList[0][2][0] =  "Keuken Screens Open"
            IOList[0][2][1] =  "Living Screens Open"
            IOList[0][2][2] =  "Slaapkamer Screen Open"
            IOList[0][2][3] =  "Vide Screen Open"
            IOList[0][2][4] =  "Keuken Rollekes Open"
            IOList[0][2][5] =  "Living Rollekes Open"
            IOList[0][2][6] =  "Slaapkamer Rolleke Open"
            IOList[0][2][7] =  "Vide Rolleke Open"
            IOList[0][2][8] =  "Overloop Rolleke Open"
			
			// Varia
            IOList[0][2][9] =  "Kelder Compressor On"
            IOList[0][2][10] =  nil
            IOList[0][2][11] =  nil
            IOList[0][2][12] =  nil
            IOList[0][2][13] =  nil
            IOList[0][2][14] =  nil
            IOList[0][2][15] =  nil
            
            // Window Coverings feedback Down
            IOList[0][3][0] =  "Keuken Screens Close"
            IOList[0][3][1] =  "Living Screens Close"
            IOList[0][3][2] =  "Slaapkamer Screen Close"
            IOList[0][3][3] =  "Vide Screen Close"
            IOList[0][3][4] =  "Keuken Rollekes Close"
            IOList[0][3][5] =  "Living Rollekes Close"
            IOList[0][3][6] =  "Slaapkamer Rolleke Close"
            IOList[0][3][7] =  "Vide Rolleke Close"
            IOList[0][3][8] =  "Overloop Rolleke Close"
            IOList[0][3][9] =  nil
            IOList[0][3][10] =  nil
            IOList[0][3][11] =  nil
            IOList[0][3][12] =  "Hal Functietoets Voordeur"
            IOList[0][3][13] =  "SlaapKamer Functietoets Bed Anja"
            IOList[0][3][14] =  "SlaapKamer Functietoets Bed Jan"
            IOList[0][3][15] =  "Overloop Functietoets"
            
            // Digital outputput 4...6
            // Lights
            IOList[0][4][14] =  "Buiten Licht Enable"
            IOList[0][4][15] =  "Overloop Licht Enable"
            IOList[0][4][2] =  "Badkamer Licht"
            IOList[0][4][3] =  "Badkamer Licht spiegel"
            IOList[0][4][4] =  "Kelder Licht"
            IOList[0][4][5] =  "Garage Licht"
            IOList[0][4][6] =  "Garage Licht Werkbank"
            IOList[0][4][7] =  "Keuken Licht"
            IOList[0][4][8] =  "Keuken Licht kast"
            IOList[0][4][9] =  "Bureau Licht"
            IOList[0][4][10] =  "Eetkamer Licht"
            IOList[0][4][11] =  "Dressing Licht"
            IOList[0][4][12] =  nil
            IOList[0][4][13] =  "Overloop Licht"
            IOList[0][4][14] =  "Hal Licht"
            IOList[0][4][15] =  "W.C. Licht"
            
            // Window Coverings
            IOList[0][5][0] =  "Keuken Screens"
            IOList[0][5][1] =  "Living Screens"
            IOList[0][5][2] =  "Slaapkamer Screen"
            IOList[0][5][3] =  "Vide Screen"
            IOList[0][5][4] =  "Keuken Rollekes"
            IOList[0][5][5] =  "Living Rollekes"
            IOList[0][5][6] =  "Slaapkamer Rolleke"
            IOList[0][5][7] =  "Vide Rolleke"
            IOList[0][5][8] =  "Overloop Rolleke"
            
            // Varia
            IOList[0][5][9] =  "Kelder Compressor"
            IOList[0][5][10] =  nil
            IOList[0][5][11] =  nil
            IOList[0][5][12] =  nil
            IOList[0][5][13] =  nil
            IOList[0][5][14] =  nil
            IOList[0][5][15] =  nil
            
            // Outlets
            IOList[0][6][0] =  "Buiten Stopcontact"
            IOList[0][6][1] =  "Garage Droogkast"
            IOList[0][6][2] =  "Garage Ventilatie"
            IOList[0][6][3] =  "Keuken Powerport"
            IOList[0][6][4] =  "Living Stopcontact"
            IOList[0][6][5] =  "Eetkamer Stopcontact"
            IOList[0][6][6] =  "Bureau Stopcontact whiteboard"
            IOList[0][6][7] =  "Bureau Stopcontact"
            IOList[0][6][8] =  "Hal Stopcontact"
            IOList[0][6][9] =  "Slaapkamer Stopcontact bed rechts"
            IOList[0][6][10] =  "Slaapkamer Stopcontact Bed links"
            IOList[0][6][11] =  "Slaapkamer Stopcontact T.V."
            IOList[0][6][12] =  "Overloop Stopcontact"
            IOList[0][6][13] =  "Voordeur"
            IOList[0][6][14] =  "Garagepoort"
            IOList[0][6][15] =  "Vrijgave beregening"
            
            return IOList
        }
        
        static var PLCobjects:[String:PLCclass] = [
            
            // Function keys / Switches
//            "Hal Functietoets Voordeur" : Switch(),
//            "SlaapKamer Functietoets Bed Anja" : Switch(),
//            "SlaapKamer Functietoets Bed Jan" : Switch(),
//            "Overloop Functietoets" : Switch(),

            // Dimmable lights
            "Badkamer Sfeerlichtjes" : DimmableLight(),
            "Slaapkamer Licht" : DimmableLight(),

            // Lights
            "Badkamer Licht" : Light(),
            "Badkamer Licht spiegel" : Light(),
            "Kelder Licht" : Light(),
            "Garage Licht" : Light(),
            "Garage Licht Werkbank" : Light(),
            "Keuken Licht kast" : Light(),
            "Keuken Licht" : Light(),
            "Bureau Licht" : Light(),
            "Eetkamer Licht" : Light(),
            "Dressing Licht" : Light(),

            "Overloop Licht" : Light(),
            "Hal Licht" : Light(),
            "W.C. Licht" : Light(),
            
            // Window Coverings
            "Keuken Screens" : WindowCovering(secondsToOpen: 35, secondsToClose: 35),
            "Living Screens" : WindowCovering(secondsToOpen: 50, secondsToClose: 50),
            "Slaapkamer Screen" : WindowCovering(secondsToOpen: 50, secondsToClose: 50),
            "Vide Screen" : WindowCovering(secondsToOpen: 35, secondsToClose: 35),
            "Keuken Rollekes" : WindowCovering(secondsToOpen: 30, secondsToClose: 30),
            "Living Rollekes" : WindowCovering(secondsToOpen: 30, secondsToClose: 30),
            "Slaapkamer Rolleke" : WindowCovering(secondsToOpen: 25, secondsToClose: 25),
            "Vide Rolleke" : WindowCovering(secondsToOpen: 25, secondsToClose: 25),
            "Overloop Rolleke" : WindowCovering(),

			// Varia
			"Kelder Compressor" : ToggleableOutlet(),
            
            
            // Outlets
            "Buiten Stopcontact" : Outlet(),
            "Garage Droogkast" : Outlet(),
            "Garage Ventilatie" : Outlet(),
            "Keuken Powerport" : Outlet(),
            "Living Stopcontact" : Outlet(),
            "Eetkamer Stopcontact" : Outlet(),
            "Bureau Stopcontact whiteboard" : Outlet(),
            "Bureau Stopcontact" : Outlet(),
            "Hal Stopcontact" : Outlet(),
            "Slaapkamer Stopcontact bed rechts" : Outlet(),
            "Slaapkamer Stopcontact Bed links" : Outlet(),
            "Slaapkamer Stopcontact T.V." : Outlet(),
            "Overloop Stopcontact" : Outlet(),
            
            // Varia
            "Voordeur" : Doorlock(),
            "Garagepoort" : GarageDoor(),
//            "Vrijgave beregening" : SmartSprinkler(),

        ]
    }
    
}
