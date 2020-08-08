//
//  HomeKitConfiguration.swift
//  HAPiNest
//
//  Created by Jan Verrept on 08/11/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Foundation
import JVCocoa
import HAP

// Global config
let bridgeName = "NestBridge"
let bridgeSetupCode = "456-77-890"

extension HomeKitServer{
    
    public func addAccessories(){
        
        mainBridge.addDriver(modBusDriver0, withAcccesories:
                                [
                                    // Feedback Lights
                                    Accessory.Lightbulb(info: Service.Info(name: "Badkamer Sfeerlichtjes", serialNumber: "00002"), type:.monochrome, isDimmable: true),
                                    Accessory.Lightbulb(info: Service.Info(name: "Slaapkamer Licht", serialNumber: "00003"), type:.monochrome, isDimmable: true),
                                ]
        )


//        mainBridge.addDriver(modBusDriver1, withAcccesories:
//                                [
//                                    // Feedback Lights
//                                    Accessory.Switch(info: Service.Info(name: "Badkamer Licht", serialNumber: "00100")),
//                                    Accessory.Switch(info: Service.Info(name: "Badkamer Licht spiegel", serialNumber: "00101")),
//                                    Accessory.Switch(info: Service.Info(name: "Kelder Licht", serialNumber: "00102")),
//                                    Accessory.Switch(info: Service.Info(name: "Buiten Licht", serialNumber: "00103")),
//                                    Accessory.Switch(info: Service.Info(name: "Garage Licht", serialNumber: "00104")),
//                                    Accessory.Switch(info: Service.Info(name: "Garage Licht Werkbank", serialNumber: "00105")),
//                                    Accessory.Switch(info: Service.Info(name: "Keuken Licht kast", serialNumber: "00106")),
//                                    Accessory.Switch(info: Service.Info(name: "Keuken Licht", serialNumber: "00107")),
//                                    Accessory.Switch(info: Service.Info(name: "Bureau Licht", serialNumber: "00108")),
//                                    Accessory.Switch(info: Service.Info(name: "Eetkamer Licht", serialNumber: "00109")),
//                                    Accessory.Switch(info: Service.Info(name: "Hal Licht", serialNumber: "00110")),
//                                    Accessory.Switch(info: Service.Info(name: "W.C. Licht", serialNumber: "00111")),
//                                    Accessory.Switch(info: Service.Info(name: "Overloop Licht", serialNumber: "00112")),
//                                    Accessory.Switch(info: Service.Info(name: "Dressing Licht", serialNumber: "00113"))
//
//                                ]
//
//        )
//
//
//        mainBridge.addDriver(modBusDriver2, withAcccesories:
//                                [
//                                    // Feedback Window coverings Up
//                                    Accessory.Switch(info: Service.Info(name: "Keuken Screen Op", serialNumber: "00200")),
//                                    Accessory.Switch(info: Service.Info(name: "Living Screen Op", serialNumber: "00201")),
//                                    Accessory.Switch(info: Service.Info(name: "Slaapkamer Screen Op", serialNumber: "00202")),
//                                    Accessory.Switch(info: Service.Info(name: "Vide Screen Op", serialNumber: "00203")),
//                                    Accessory.Switch(info: Service.Info(name: "Keuken Rolgordijn Op", serialNumber: "00204")),
//                                    Accessory.Switch(info: Service.Info(name: "Living Rolgordijn Op", serialNumber: "00205")),
//                                    Accessory.Switch(info: Service.Info(name: "Slaapkamer Rolgordijn Op", serialNumber: "00206")),
//                                    Accessory.Switch(info: Service.Info(name: "Vide Rolgordijn Op", serialNumber: "00207")),
//                                    Accessory.Switch(info: Service.Info(name: "Overloop Rolgordijn Op", serialNumber: "00208"))
//                                ]
//        )

//        mainBridge.addDriver(modBusDriver3, withAcccesories:
//                                [
//                                    // Feedback Window coverings Down
//                                    Accessory.Switch(info: Service.Info(name: "Keuken Screen Neer", serialNumber: "00300")),
//                                    Accessory.Switch(info: Service.Info(name: "Living Screen Neer", serialNumber: "00301")),
//                                    Accessory.Switch(info: Service.Info(name: "Slaapkamer Screen Neer", serialNumber: "00302")),
//                                    Accessory.Switch(info: Service.Info(name: "Vide Screen Neer", serialNumber: "00303")),
//                                    Accessory.Switch(info: Service.Info(name: "Keuken Rolgordijn Neer", serialNumber: "00304")),
//                                    Accessory.Switch(info: Service.Info(name: "Living Rolgordijn Neer", serialNumber: "00305")),
//                                    Accessory.Switch(info: Service.Info(name: "Slaapkamer Rolgordijn Neer", serialNumber: "00306")),
//                                    Accessory.Switch(info: Service.Info(name: "Vide Rolgordijn Neer", serialNumber: "00307")),
//                                    Accessory.Switch(info: Service.Info(name: "Overloop Rolgordijn Neer", serialNumber: "00308"))
//                                ]
//        )

        mainBridge.addDriver(modBusDriver4, withAcccesories:
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

        mainBridge.addDriver(modBusDriver5, withAcccesories:
                                [
                                    // Window coverings
                                    Accessory.WindowCovering(info: Service.Info(name: "Keuken Screens", serialNumber: "00500")),
                                    Accessory.WindowCovering(info: Service.Info(name: "Living Screens", serialNumber: "00501")),
                                    Accessory.WindowCovering(info: Service.Info(name: "Slaapkamer Screen", serialNumber: "00502")),
                                    Accessory.WindowCovering(info: Service.Info(name: "Vide Screen", serialNumber: "00503")),
                                    Accessory.WindowCovering(info: Service.Info(name: "Keuken Rolgordijns", serialNumber: "00504")),
                                    Accessory.WindowCovering(info: Service.Info(name: "Living Rolgordijns", serialNumber: "00505")),
                                    Accessory.WindowCovering(info: Service.Info(name: "Slaapkamer Rolgordijn", serialNumber: "00506")),
                                    Accessory.WindowCovering(info: Service.Info(name: "Vide Rolgordijn", serialNumber: "00507")),
                                    Accessory.WindowCovering(info: Service.Info(name: "Overloop Rolgordijn", serialNumber: "00508")),
                                    Accessory.GarageDoorOpener(info: Service.Info(name: "Garage Poort", serialNumber: "00514")),
                                    Accessory.LockMechanism(info: Service.Info(name: "Voordeur", serialNumber: "00515"))
                                ]
        )

        mainBridge.addDriver(modBusDriver6, withAcccesories:
                                [
                                    // Window Outlets
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
        
        mainBridge.addDriver(milightDriver, withAcccesories:
                                [
                                    // Lights
                                    Accessory.Lightbulb(info: Service.Info(name: "Balk", serialNumber: "10000"), type:.color, isDimmable: true),
                                    Accessory.Lightbulb(info: Service.Info(name: "UFO", serialNumber: "10002"), type:.color, isDimmable: true),
                                ]
        )

        mainBridge.addDriver(tizenDriver1, withAcccesories:
                                [
                                    // Multimedia
                                    Accessory.Television(info: Service.Info(name: "T.V.", serialNumber: "20000"), inputs: [
                                        ("homeScreen", .homescreen),
                                        ("Eén", .application),
                                        ("Q2", .usb),
                                        ("VTM", .homescreen),
                                        ("Vier", .homescreen),
                                        ("Vijf", .homescreen),
                                        ("Zes", .homescreen),
                                        ("Canvas", .homescreen),
                                        ("Discovery", .homescreen),
                                        ("National Geographic", .homescreen),
                                        ("Animal planet", .homescreen)
                                    ])
                                ]
        )

        mainBridge.addDriver(tizenDriver2, withAcccesories:
                                [
                                    // Multimedia
                                    Accessory.Television(info: Service.Info(name: "T.V. Boven", serialNumber: "20001"), inputs: [
                                        ("homeScreen", .homescreen),
                                        ("Eén", .application),
                                        ("Q2", .usb),
                                        ("VTM", .homescreen),
                                        ("Vier", .homescreen),
                                        ("Vijf", .homescreen),
                                        ("Zes", .homescreen),
                                        ("Canvas", .homescreen),
                                        ("Discovery", .homescreen),
                                        ("National Geographic", .homescreen),
                                        ("Animal planet", .homescreen)
                                    ])
                                ]
        )

        if let yasdiDriver=self.yasdiDriver{
            mainBridge.addDriver(yasdiDriver, withAcccesories:
                                    [
                                        // Solar Inverter
                                        PowerBankAccessory(info: Service.Info(name: "Zonneënergie", serialNumber: "30000"))
                                    ]
            )
        }

    }
    
    
}
