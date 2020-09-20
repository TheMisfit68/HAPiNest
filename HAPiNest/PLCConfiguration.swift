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
            IOLogicE1241(ipAddress: "192.168.0.150"),
            IOLogicE1210(ipAddress: "192.168.0.151"),
            IOLogicE1210(ipAddress: "192.168.0.152"),
            IOLogicE1210(ipAddress: "192.168.0.153"),
            IOLogicE1211(ipAddress: "127.0.0.1",port: 1502),
            IOLogicE1211(ipAddress: "192.168.0.155"),
            IOLogicE1211(ipAddress: "192.168.0.156"),
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
            IOList[0][0][1] = "Slaapkamer Licht"
            IOList[0][0][0] = nil
            IOList[0][0][1] = nil
            
            // Digital inputs 1...3
            // Lights
            IOList[0][1][0] = "Badkamer Licht ingeschakeld"
            IOList[0][1][1] = "Badkamer Licht spiegel ingeschakeld"
            IOList[0][1][2] = "Kelder Licht ingeschakeld"
            IOList[0][1][3] = "Buiten Licht ingeschakeld"
            IOList[0][1][4] = "Garage Licht ingeschakeld"
            IOList[0][1][5] = "Garage Licht Werkbank ingeschakeld"
            IOList[0][1][6] = "Keuken Licht kast ingeschakeld"
            IOList[0][1][7] = "Keuken Licht ingeschakeld"
            IOList[0][1][8] = "Bureau Licht ingeschakeld"
            IOList[0][1][9] = "Eetkamer Licht ingeschakeld"
            IOList[0][1][10] = "Hal Licht ingeschakeld"
            IOList[0][1][11] = "W.C. Licht ingeschakeld"
            IOList[0][1][12] = "Overloop Licht ingeschakeld"
            IOList[0][1][13] = "Dressing Licht ingeschakeld"
            IOList[0][1][14] = nil
            IOList[0][1][15] = nil
            
            // Window Coverings feedback Up
            IOList[0][2][0] = "Keuken Screen Op"
            IOList[0][2][1] = "Living Screen Op"
            IOList[0][2][2] = "Slaapkamer Screen Op"
            IOList[0][2][3] = "Vide Screen Op"
            IOList[0][2][4] = "Keuken Rolgordijn Op"
            IOList[0][2][5] = "Living Rolgordijn Op"
            IOList[0][2][6] = "Slaapkamer Rolgordijn Op"
            IOList[0][2][7] = "Vide Rolgordijn Op"
            IOList[0][2][8] = "Overloop Rolgordijn Op"
            IOList[0][2][9] = nil
            IOList[0][2][10] = nil
            IOList[0][2][11] = nil
            IOList[0][2][12] = nil
            IOList[0][2][13] = nil
            IOList[0][2][14] = nil
            IOList[0][2][15] = nil
            
            // Window Coverings feedback Down
            IOList[0][3][0] = "Keuken Screen Neer"
            IOList[0][3][1] = "Living Screen Neer"
            IOList[0][3][2] = "Slaapkamer Screen Neer"
            IOList[0][3][3] = "Vide Screen Neer"
            IOList[0][3][4] = "Keuken Rolgordijn Neer"
            IOList[0][3][5] = "Living Rolgordijn Neer"
            IOList[0][3][6] = "Slaapkamer Rolgordijn Neer"
            IOList[0][3][7] = "Vide Rolgordijn Neer"
            IOList[0][3][8] = "Overloop Rolgordijn Neer"
            IOList[0][3][9] = nil
            IOList[0][3][10] = nil
            IOList[0][3][11] = nil
            IOList[0][3][12] = nil
            IOList[0][3][13] = nil
            IOList[0][3][14] = nil
            IOList[0][3][15] = nil
            
            // Digital outputput 4...6
            // Lights
            IOList[0][4][0] = "Badkamer Licht"
            IOList[0][4][1] = "Badkamer Licht spiegel"
            IOList[0][4][2] = "Kelder Licht"
            IOList[0][4][3] = "Buiten Licht"
            IOList[0][4][4] = "Garage Licht"
            IOList[0][4][5] = "Garage Licht Werkbank"
            IOList[0][4][6] = "Keuken Licht kast"
            IOList[0][4][7] = "Keuken Licht"
            IOList[0][4][8] = "Bureau Licht"
            IOList[0][4][9] = "Eetkamer Licht"
            IOList[0][4][10] = "Hal Licht"
            IOList[0][4][11] = "W.C. Licht"
            IOList[0][4][12] = "Overloop Licht"
            IOList[0][4][13] = "Dressing Licht"
            IOList[0][4][14] = nil
            IOList[0][4][15] = nil
            
            // Window Coverings
            IOList[0][5][0] = "Keuken Screens"
            IOList[0][5][1] = "Living Screens"
            IOList[0][5][2] = "Slaapkamer Screen"
            IOList[0][5][3] = "Vide Screen"
            IOList[0][5][4] = "Keuken Rolgordijnen"
            IOList[0][5][5] = "Living Rolgordijnen"
            IOList[0][5][6] = "Slaapkamer Rolgordijn"
            IOList[0][5][7] = "Vide Rolgordijn"
            IOList[0][5][8] = "Overloop Rolgordijn"
            IOList[0][5][9] = nil
            IOList[0][5][10] = nil
            IOList[0][5][11] = nil
            IOList[0][5][12] = nil
            IOList[0][5][13] = nil
            
            // Varia
            IOList[0][5][14] = "Garage Poort"
            IOList[0][5][15] = "Voordeur"
            
            // Outlets
            IOList[0][6][0] = "Kelder Compressor"
            IOList[0][6][1] = "Buiten Stopcontact"
            IOList[0][6][2] = "Garage Droogkast"
            IOList[0][6][3] = "Garage Ventilatie"
            IOList[0][6][4] = "Keuken Powerport"
            IOList[0][6][5] = "Living Stopcontact barkast"
            IOList[0][6][6] = "Living Stopcontact trap"
            IOList[0][6][7] = "Bureau Stopcontact whiteboard"
            IOList[0][6][8] = "Bureau Stopcontact"
            IOList[0][6][9] = "Hal Stopcontact"
            IOList[0][6][10] = "Slaapkamer Stopcontact bed rechts"
            IOList[0][6][11] = "Slaapkamer Stopcontact Bed links"
            IOList[0][6][12] = "Slaapkamer Stopcontact T.V."
            IOList[0][6][13] = "Overloop Stopcontact"
            IOList[0][6][14] = nil
            IOList[0][6][15] = nil
            
            return IOList
        }
     
        static var PLCobjects:[String:PLCclass]{
            
            var PLCobjects:[SoftPLC.Symbol:PLCclass] = [:]
            
            // Dimmable lights
            PLCobjects["Badkamer Sfeerlichtjes"] = DimmableLight()
            PLCobjects["Slaapkamer Licht"] = DimmableLight()
            
            // Lights
            PLCobjects["Badkamer Licht"] = Light()
            PLCobjects["Badkamer Licht spiegel"] = Light()
            PLCobjects["Kelder Licht"] = Light()
            PLCobjects["Buiten Licht"] = Light()
            PLCobjects["Garage Licht"] = Light()
            PLCobjects["Garage Licht Werkbank"] = Light()
            PLCobjects["Keuken Licht kast"] = Light()
            PLCobjects["Keuken Licht"] = Light()
            PLCobjects["Bureau Licht"] = Light()
            PLCobjects["Eetkamer Licht"] = Light()
            PLCobjects["Hal Licht"] = Light()
            PLCobjects["W.C. Licht"] = Light()
            PLCobjects["Overloop Licht"] = Light()
            PLCobjects["Dressing Licht"] = Light()
            
            // Window Coverings
            PLCobjects["Keuken Screens"] = WindowCovering()
            PLCobjects["Living Screens"] = WindowCovering()
            PLCobjects["Slaapkamer Screen"] = WindowCovering()
            PLCobjects["Vide Screen"] = WindowCovering()
            PLCobjects["Keuken Rolgordijnen"] = WindowCovering()
            PLCobjects["Living Rolgordijnen"] = WindowCovering()
            PLCobjects["Slaapkamer Rolgordijn"] = WindowCovering()
            PLCobjects["Vide Rolgordijn"] = WindowCovering()
            PLCobjects["Overloop Rolgordijn"] = WindowCovering()
        
            // Varia
            PLCobjects["Garage Poort"] = GaragePort()
            PLCobjects["Voordeur"] = Doorlock()
            
            // Outlets
            PLCobjects["Kelder Compressor"] = Outlet()
            PLCobjects["Buiten Stopcontact"] = Outlet()
            PLCobjects["Garage Droogkast"] = Outlet()
            PLCobjects["Garage Ventilatie"] = Outlet()
            PLCobjects["Keuken Powerport"] = Outlet()
            PLCobjects["Living Stopcontact barkast"] = Outlet()
            PLCobjects["Living Stopcontact trap"] = Outlet()
            PLCobjects["Bureau Stopcontact whiteboard"] = Outlet()
            PLCobjects["Bureau Stopcontact"] = Outlet()
            PLCobjects["Hal Stopcontact"] = Outlet()
            PLCobjects["Slaapkamer Stopcontact bed rechts"] = Outlet()
            PLCobjects["Slaapkamer Stopcontact Bed links"] = Outlet()
            PLCobjects["Slaapkamer Stopcontact T.V."] = Outlet()
            PLCobjects["Overloop Stopcontact"] = Outlet()
            
            return PLCobjects
            
        }
        
    }
    
}
