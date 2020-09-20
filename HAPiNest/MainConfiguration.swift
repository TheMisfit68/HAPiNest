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

struct MainConfiguration{
    
     struct HomeKit{
        
        static let BridgeName = "NestBridge"
        static let BridgeSetupCode = "456-77-890"
        
        static public func AddAccessories(){
            
            let appDelegate:AppDelegate = (NSApplication.shared.delegate) as! AppDelegate
            let plc:SoftPLC = appDelegate.plc!
                    
            HomeKitServer.shared.mainBridge.addDriver(plc, withAcccesories:
                                    [
                                        // Dimmable Lights
                                        Accessory.Lightbulb(info: Service.Info(name: "Badkamer Sfeerlichtjes", serialNumber: "00002"), type:.monochrome, isDimmable: true),
                                        Accessory.Lightbulb(info: Service.Info(name: "Slaapkamer Licht", serialNumber: "00003"), type:.monochrome, isDimmable: true),
                                    ]
            )
            
            
            HomeKitServer.shared.mainBridge.addDriver(plc, withAcccesories:
                                    [
                                        // Lights
                                        Accessory.Lightbulb(info: Service.Info(name: "Badkamer Licht", serialNumber: "00400")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Badkamer Licht spiegel", serialNumber: "00401")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Kelder Licht", serialNumber: "00402")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Buiten Licht", serialNumber: "00403")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Garage Licht", serialNumber: "00404")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Garage Licht Werkbank", serialNumber: "00405")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Keuken Licht kast", serialNumber: "00406")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Keuken Licht", serialNumber: "00407")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Bureau Licht", serialNumber: "00408")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Eetkamer Licht", serialNumber: "00409")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Hal Licht", serialNumber: "00410")),
                                        Accessory.Lightbulb(info: Service.Info(name: "W.C. Licht", serialNumber: "00411")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Overloop Licht", serialNumber: "00412")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Dressing Licht", serialNumber: "00413"))
                                    ]
            )
            
            HomeKitServer.shared.mainBridge.addDriver(plc, withAcccesories:
                                    [
                                        // Window coverings
                                        Accessory.WindowCovering(info: Service.Info(name: "Keuken Screens", serialNumber: "00500")),
                                        Accessory.WindowCovering(info: Service.Info(name: "Living Screens", serialNumber: "00501")),
                                        Accessory.WindowCovering(info: Service.Info(name: "Slaapkamer Screen", serialNumber: "00502")),
                                        Accessory.WindowCovering(info: Service.Info(name: "Vide Screen", serialNumber: "00503")),
                                        Accessory.WindowCovering(info: Service.Info(name: "Keuken Rolgordijnen", serialNumber: "00504")),
                                        Accessory.WindowCovering(info: Service.Info(name: "Living Rolgordijnen", serialNumber: "00505")),
                                        Accessory.WindowCovering(info: Service.Info(name: "Slaapkamer Rolgordijn", serialNumber: "00506")),
                                        Accessory.WindowCovering(info: Service.Info(name: "Vide Rolgordijn", serialNumber: "00507")),
                                        Accessory.WindowCovering(info: Service.Info(name: "Overloop Rolgordijn", serialNumber: "00508")),
                                        Accessory.GarageDoorOpener(info: Service.Info(name: "Garage Poort", serialNumber: "00514")),
                                        Accessory.LockMechanism(info: Service.Info(name: "Voordeur", serialNumber: "00515"))
                                    ]
            )
            
            HomeKitServer.shared.mainBridge.addDriver(plc, withAcccesories:
                                    [
                                        // Outlets
                                        Accessory.Outlet(info: Service.Info(name: "Kelder Compressor", serialNumber: "00600")),
                                        Accessory.Lightbulb(info: Service.Info(name: "Buiten Stopcontact", serialNumber: "00601")),
                                        Accessory.Outlet(info: Service.Info(name: "Garage Droogkast", serialNumber: "00602")),
                                        Accessory.Outlet(info: Service.Info(name: "Garage Ventilatie", serialNumber: "00603")),
                                        Accessory.Outlet(info: Service.Info(name: "Keuken Powerport", serialNumber: "00604")),
                                        Accessory.Outlet(info: Service.Info(name: "Living Stopcontact", serialNumber: "00605")),
                                        Accessory.Outlet(info: Service.Info(name: "Eetkamer Stopcontact", serialNumber: "00606")),
                                        Accessory.Outlet(info: Service.Info(name: "Bureau Stopcontact whiteboard", serialNumber: "00607")),
                                        Accessory.Outlet(info: Service.Info(name: "Bureau Stopcontact", serialNumber: "00608")),
                                        Accessory.Outlet(info: Service.Info(name: "Hal Stopcontact", serialNumber: "00609")),
                                        Accessory.Outlet(info: Service.Info(name: "Slaapkamer Stopcontact bed rechts", serialNumber: "00610")),
                                        Accessory.Outlet(info: Service.Info(name: "Slaapkamer Stopcontact Bed links", serialNumber: "00611")),
                                        Accessory.Outlet(info: Service.Info(name: "Slaapkamer Stopcontact T.V.", serialNumber: "00612")),
                                        Accessory.Outlet(info: Service.Info(name: "Overloop Stopcontact", serialNumber: "00613"))
                                    ]
            )
            
            HomeKitServer.shared.mainBridge.addDriver(HomeKitServer.shared.milightDriver, withAcccesories:
                                    [
                                        // Lights
                                        Accessory.Lightbulb(info: Service.Info(name: "Balk", serialNumber: "10000"), type:.color, isDimmable: true),
                                        Accessory.Lightbulb(info: Service.Info(name: "UFO", serialNumber: "10002"), type:.color, isDimmable: true),
                                    ]
            )
            
            // Multimedia
            HomeKitServer.shared.mainBridge.addDriver(HomeKitServer.shared.tizenDriver1, withAcccesories:
                                    [
                                        // Use 'InputSource'-selector to switch channels instead
                                        Accessory.Television(info: Service.Info(name: "T.V.", serialNumber: "20000"), inputs: [
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
                                            ("YouTube", .application)
                                        ])
                                    ]
            )
            
            HomeKitServer.shared.mainBridge.addDriver(HomeKitServer.shared.tizenDriver2, withAcccesories:
                                    [
                                        // Use 'InputSource'-selector to switch channels instead
                                        Accessory.Television(info: Service.Info(name: "T.V. Boven", serialNumber: "20001"), inputs: [
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
                                            ("YouTube", .application)
                                        ])
                                    ]
            )
            
            // Solar Panels
//            if let yasdiDriver=HomeKitServer.shared.yasdiDriver{
//                HomeKitServer.shared.mainBridge.addDriver(yasdiDriver, withAcccesories:
//                                        [
//                                            // Solar Inverter
//                                            PowerBankAccessory(info: Service.Info(name: "Zonneënergie", serialNumber: "30000"))
//                                        ]
//                )
//            }
        }
        
    }
    
    
}

