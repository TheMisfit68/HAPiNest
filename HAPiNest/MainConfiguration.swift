//
//  HomeKitConfiguration.swift
//  HAPiNest
//
//  Created by Jan Verrept on 08/11/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Cocoa
import JVCocoa
import HAP

import SoftPLC
import MilightDriver
import TizenDriver
import LeafDriver
//import YASDIDriver

struct MainConfiguration{
    
    struct HomeKit{
        
		static let ServerName:String = "HAPiNestServer"
		static let ServerPort = 8888
        static let BridgeName = "NestBridge"
        static let BridgeSetupCode = "456-77-890"
		static let BridgeConfigFile = "configuration.json"
        
        static let PLCobjects = PLC.PLCobjects.mapValues{$0 as! AccessoryDelegate}
        static let Accessories:[ (Accessory,AccessoryDelegate?) ] = [
            
            // MARK: - Dimmable Lights
            ( Accessory.Lightbulb(info: Service.Info (name: "Badkamer Sfeerlichtjes", serialNumber: "00002", manufacturer: "MOXA"), isDimmable: true),   PLCobjects["Badkamer Sfeerlichtjes"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "Slaapkamer Licht", serialNumber: "00003", manufacturer: "MOXA"), isDimmable: true),          PLCobjects["Slaapkamer Licht"] ),
            
            // MARK: - Lights
			( Accessory.Lightbulb(info: Service.Info(name: "Schemerschakelaar Enable", serialNumber: "00403")),  PLCobjects["Schemerschakelaar Enable"] ),
			
            ( Accessory.Lightbulb(info: Service.Info(name: "Badkamer Licht", serialNumber: "00400")),            PLCobjects["Badkamer Licht"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "Badkamer Licht spiegel", serialNumber: "00401")),    PLCobjects["Badkamer Licht spiegel"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "Kelder Licht", serialNumber: "00402")),              PLCobjects["Kelder Licht"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "Garage Licht", serialNumber: "00404")),              PLCobjects["Garage Licht"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "Garage Licht Werkbank", serialNumber: "00405")),     PLCobjects["Garage Licht Werkbank"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "Keuken Licht kast", serialNumber: "00406")),         PLCobjects["Keuken Licht kast"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "Keuken Licht", serialNumber: "00407")),              PLCobjects["Keuken Licht"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "Bureau Licht", serialNumber: "00408")),              PLCobjects["Bureau Licht"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "Eetkamer Licht", serialNumber: "00409")),            PLCobjects["Eetkamer Licht"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "Hal Licht", serialNumber: "00410")),                 PLCobjects["Hal Licht"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "W.C. Licht", serialNumber: "00411")),                PLCobjects["W.C. Licht"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "Overloop Licht", serialNumber: "00412")),            PLCobjects["Overloop Licht"] ),
            ( Accessory.Lightbulb(info: Service.Info(name: "Dressing Licht", serialNumber: "00413")),            PLCobjects["Dressing Licht"] ),
            
            
            // Window coverings
            ( Accessory.WindowCovering(info: Service.Info(name: "Keuken Screens", serialNumber: "00500")),			PLCobjects["Keuken Screens"] ),
            ( Accessory.WindowCovering(info: Service.Info(name: "Living Screens", serialNumber: "00501")),			PLCobjects["Living Screens"] ),
            ( Accessory.WindowCovering(info: Service.Info(name: "Slaapkamer Screen", serialNumber: "00502")),		PLCobjects["Slaapkamer Screen"] ),
            ( Accessory.WindowCovering(info: Service.Info(name: "Vide Screen", serialNumber: "00503")),				PLCobjects["Vide Screen"] ),
            ( Accessory.WindowCovering(info: Service.Info(name: "Keuken Rollekes", serialNumber: "00504")),		PLCobjects["Keuken Rollekes"] ),
            ( Accessory.WindowCovering(info: Service.Info(name: "Living Rollekes", serialNumber: "00505")),		PLCobjects["Living Rollekes"] ),
            ( Accessory.WindowCovering(info: Service.Info(name: "Slaapkamer Rolleke", serialNumber: "00506")),	PLCobjects["Slaapkamer Rolleke"] ),
            ( Accessory.WindowCovering(info: Service.Info(name: "Vide Rolleke", serialNumber: "00507")),      	PLCobjects["Vide Rolleke"] ),
            ( Accessory.WindowCovering(info: Service.Info(name: "Overloop Rolleke", serialNumber: "00508")),  	PLCobjects["Overloop Rolleke"] ),
            
            
            // MARK: - Security
            ( Accessory.LockMechanism(info: Service.Info(name: "Voordeur", serialNumber: "00550")), PLCobjects["Voordeur"] ),
            ( Accessory.GarageDoorOpener.StatelessGarageDoorOpener(info: Service.Info(name: "Garagepoort", serialNumber: "00551")), PLCobjects["Garagepoort"] ),

            
            // MARK: - Sprinkler
            ( Accessory.SmartSprinkler(info: Service.Info(name: "Vrijgave beregening", serialNumber: "00552", manufacturer: "Hunter")), PLCobjects["Vrijgave beregening"] ),
            
            // Outlets
            ( Accessory.Outlet(info: Service.Info(name: "Kelder Compressor", serialNumber: "00600", manufacturer: "Niko")),                 PLCobjects["Kelder Compressor"] ),
            ( Accessory.Outlet(info: Service.Info(name: "Buiten Stopcontact", serialNumber: "00601", manufacturer: "Niko")),                PLCobjects["Buiten Stopcontact"] ),
            ( Accessory.Outlet(info: Service.Info(name: "Garage Droogkast", serialNumber: "00602", manufacturer: "Niko")),                  PLCobjects["Garage Droogkast"] ),
            ( Accessory.Outlet(info: Service.Info(name: "Garage Ventilatie", serialNumber: "00603", manufacturer: "Niko")),                 PLCobjects["Garage Ventilatie"] ),
            ( Accessory.Outlet(info: Service.Info(name: "Keuken Powerport", serialNumber: "00604", manufacturer: "Niko")),                  PLCobjects["Keuken Powerport"] ),
            ( Accessory.Outlet(info: Service.Info(name: "Living Stopcontact", serialNumber: "00605", manufacturer: "Niko")),                PLCobjects["Living Stopcontact"] ),
            ( Accessory.Outlet(info: Service.Info(name: "Eetkamer Stopcontact", serialNumber: "00606", manufacturer: "Niko")),              PLCobjects["Eetkamer Stopcontact"] ),
            ( Accessory.Outlet(info: Service.Info(name: "Bureau Stopcontact whiteboard", serialNumber: "00607", manufacturer: "Niko")),     PLCobjects["Bureau Stopcontact whiteboard"] ),
            ( Accessory.Outlet(info: Service.Info(name: "Bureau Stopcontact", serialNumber: "00608", manufacturer: "Niko")),                PLCobjects["Bureau Stopcontact"] ),
            ( Accessory.Outlet(info: Service.Info(name: "Hal Stopcontact", serialNumber: "00609", manufacturer: "Niko")),                   PLCobjects["Hal Stopcontact"] ),
            ( Accessory.Outlet(info: Service.Info(name: "Slaapkamer Stopcontact bed rechts", serialNumber: "00610", manufacturer: "Niko")), PLCobjects["Slaapkamer Stopcontact bed rechts"] ),
            ( Accessory.Outlet(info: Service.Info(name: "Slaapkamer Stopcontact Bed links", serialNumber: "00611", manufacturer: "Niko")),  PLCobjects["Slaapkamer Stopcontact Bed links"] ),
            ( Accessory.Outlet(info: Service.Info(name: "Slaapkamer Stopcontact T.V.", serialNumber: "00612", manufacturer: "Niko")),       PLCobjects["Slaapkamer Stopcontact T.V."] ),
            ( Accessory.Outlet(info: Service.Info(name: "Overloop Stopcontact", serialNumber: "00613", manufacturer: "Niko")),              PLCobjects["Overloop Stopcontact"] ),
            
            
            // MARK: - Smart Lights
			( Accessory.Lightbulb(info: Service.Info(name: "Balk", serialNumber: "10000", manufacturer: "Milight"), type: .color, isDimmable: true),  MilightDelegate(name: "Balk", driver:MilightDriverV6(ipAddress:"192.168.0.52"), zone: .zone01) ),
			( Accessory.Lightbulb(info: Service.Info(name: "UFO", serialNumber: "10002", manufacturer: "Milight"), type: .color, isDimmable: true),     MilightDelegate(name: "UFO", driver:MilightDriverV6(ipAddress:"192.168.0.52"), zone: .zone02) ),

            
            // MARK: - T.V.s
            // Use 'InputSource'-selectors to switch channels instead
           (  Accessory.Television(info: Service.Info(name: "T.V.", serialNumber: "20000", manufacturer: "Samsung"),
                                       inputs: [
                                        ("homeScreen", .hdmi),
                                        ("Eén", .hdmi),
                                        ("Q2", .hdmi),
                                        ("VTM", .hdmi),
                                        ("Vier", .hdmi),
                                        ("Vijf", .hdmi),
                                        ("Zes", .hdmi),
                                        ("Canvas", .hdmi),
                                        ("Discovery", .hdmi),
                                        ("National Geographic", .hdmi),
                                        ("Animal planet", .hdmi),
                                        ("Netflix", .application),
                                        ("YouTube", .application),
										("Camera straat", .application),
										("Camera tuin", .application)
                                       ]),
              TizenDelegate(tvName:"T.V.", macAddress: "F8:3F:51:2E:C5:F1", ipAddress: "192.168.0.50", port: 8002, deviceName: "HAPiNestServer")
                
            ),
            
            (  Accessory.Television(info: Service.Info(name: "T.V. Boven", serialNumber: "20001", manufacturer: "Samsung"),
                                        inputs: [
                                         ("homeScreen", .hdmi),
                                         ("Eén", .hdmi),
                                         ("Q2", .hdmi),
                                         ("VTM", .hdmi),
                                         ("Vier", .hdmi),
                                         ("Vijf", .hdmi),
                                         ("Zes", .hdmi),
                                         ("Canvas", .hdmi),
                                         ("Discovery", .hdmi),
                                         ("National Geographic", .hdmi),
                                         ("Animal planet", .hdmi),
                                         ("Netflix", .application),
                                         ("YouTube", .application),
										 ("Camera straat", .application),
										 ("Camera tuin", .application)                                        ]),
               TizenDelegate(tvName:"T.V. Boven", macAddress: "7C:64:56:80:4E:90", ipAddress: "192.168.0.116", port: 8002, deviceName: "HAPiNestServer")
                 
             ),
            

//            // MARK: - Other
//            Accessory.init(info: Service.Info(name: "Auto", serialNumber: "30000", manufacturer: "Nissan"),
//                           type: .other,
//                           services: [
//                            // TODO: - Insert Service.Battery or Service.EnergyMeter,
//                            // once it gets supported by Apples 'Home'-App
//                            .ThermostatBase(characteristics:[.name("Gewenste Temperatuur")] ),
//                            .SwitchBase(characteristics:[.name("Airco inschakelen")] ),
//                            .SwitchBase(characteristics:[.name("Start opladen")] ),
//                           ] ),
//            LeafDriver(leafProtocol: LeafProtocolV2())
//            ),
//            
//            Accessory.init(info: Service.Info(name: "Zonnepanelen", serialNumber: "30001", manufacturer: "SMA"),
//                           type: .other,
//                           services: [
//                            // TODO: - Insert a Service.EnergyMeter and Service.PowerMeter,
//                            // once it gets supported by Apples 'Home'-App
//                            .SwitchBase(characteristics:[.name("Opbrengst opvragen")] ),
//                           ] ),
//            YASDIDriver.InstallDrivers().first!
//            )
        ]
        
    }
}

