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
import ModbusDriver
import MilightDriver
import TizenDriver
import LeafDriver
import Network
//import YASDIDriver

struct MainConfiguration{
    
    struct HomeKitServer{
        
#if DEBUG
        static let ServerName:String = "DevHAPiNestServer"
        static let ServerPort = 8123
        static let BridgeName = "DevelopmentNestBridge"
        static let BridgeSetupCode = "012-34-567"
        static let BridgeConfigFile = "DevelopmentConfiguration.json"
#else
        static let ServerName:String = "HAPiNestServer"
        static let ServerPort = 8888
        static let BridgeName = "NestBridge"
        static let BridgeSetupCode = "456-77-890"
        static let BridgeConfigFile = "configuration.json"
#endif
    }
    
    static let Accessories:[Accessory : any AccessoryDelegate] =
    [
        
        // MARK: - Dimmable Lights
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Bathroom Mood Lights", table:"AccessoryNames"), serialNumber: "00002", manufacturer: "MOXA"), isDimmable: true) : PLCAccessoryDelegate(),
        
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Bedroom Light", table:"AccessoryNames"), serialNumber: "00003", manufacturer: "MOXA"), isDimmable: true) : PLCAccessoryDelegate(),
        
        // MARK: - Lights
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Twilight Sensor Enable", table:"AccessoryNames"), serialNumber: "00400")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Landing Light Enable", table:"AccessoryNames"), serialNumber: "00401")) : PLCAccessoryDelegate(),
        
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Bathroom Light", table:"AccessoryNames"), serialNumber: "00402")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Bathroom mirror Light", table:"AccessoryNames"), serialNumber: "00403")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Basement Light", table:"AccessoryNames"), serialNumber: "00404")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Garage Light", table:"AccessoryNames"), serialNumber: "00405")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Garage workbench Light", table:"AccessoryNames"), serialNumber: "00406")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Kitchen cabinet Light", table:"AccessoryNames"), serialNumber: "00407")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Kitchen Light", table:"AccessoryNames"), serialNumber: "00408")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Office Light", table:"AccessoryNames"), serialNumber: "00409")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Dining room Light", table:"AccessoryNames"), serialNumber: "00410")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Hallway Light", table:"AccessoryNames"), serialNumber: "00411")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Toilet Light", table:"AccessoryNames"), serialNumber: "00412")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Landing Light", table:"AccessoryNames"), serialNumber: "00413")) : PLCAccessoryDelegate(),
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Dressing room Light", table:"AccessoryNames"), serialNumber: "00414")) : PLCAccessoryDelegate(),
        
        
        // MARK: - Window coverings
        Accessory.WindowCovering(info: Service.Info(name:String(localized:"Kitchen Screens", table:"AccessoryNames"), serialNumber: "00500")) : PLCAccessoryDelegate(),
        Accessory.WindowCovering(info: Service.Info(name:String(localized:"Living room Screens", table:"AccessoryNames"), serialNumber: "00501")) : PLCAccessoryDelegate(),
        Accessory.WindowCovering(info: Service.Info(name:String(localized:"Bedroom Screen", table:"AccessoryNames"), serialNumber: "00502")) : PLCAccessoryDelegate(),
        Accessory.WindowCovering(info: Service.Info(name:String(localized:"Loft Screen", table:"AccessoryNames"), serialNumber: "00503")) : PLCAccessoryDelegate(),
        Accessory.WindowCovering(info: Service.Info(name:String(localized:"Kitchen Blinds", table:"AccessoryNames"), serialNumber: "00504")) : PLCAccessoryDelegate(),
        Accessory.WindowCovering(info: Service.Info(name:String(localized:"Living room Blinds", table:"AccessoryNames"), serialNumber: "00505")) : PLCAccessoryDelegate(),
        Accessory.WindowCovering(info: Service.Info(name:String(localized:"Bedroom Blinds", table:"AccessoryNames"), serialNumber: "00506")) : PLCAccessoryDelegate(),
        Accessory.WindowCovering(info: Service.Info(name:String(localized:"Loft Blinds", table:"AccessoryNames"), serialNumber: "00507")) : PLCAccessoryDelegate(),
        Accessory.WindowCovering(info: Service.Info(name:String(localized:"Landing Blinds", table:"AccessoryNames"), serialNumber: "00508")) : PLCAccessoryDelegate(),
        
        
        // MARK: - Security
        Accessory.LockMechanism(info: Service.Info(name:String(localized:"Front Door", table:"AccessoryNames"), serialNumber: "00550"))  : PLCAccessoryDelegate(),
        Accessory.GarageDoorOpener.StatelessGarageDoorOpener(info: Service.Info(name:String(localized:"Garage Door", table:"AccessoryNames"), serialNumber: "00551")) : PLCAccessoryDelegate(),
        
        // MARK: - Outlet
        Accessory.Outlet(info: Service.Info(name:String(localized:"Basement Compressor", table:"AccessoryNames"), serialNumber: "00600", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Outdoor Power Outlet", table:"AccessoryNames"), serialNumber: "00601", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Garage Dryer", table:"AccessoryNames"), serialNumber: "00602", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Garage Ventilation", table:"AccessoryNames"), serialNumber: "00603", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Kitchen Powerport", table:"AccessoryNames"), serialNumber: "00604", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Living room Power Outlet", table:"AccessoryNames"), serialNumber: "00605", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Dining room Power Outlet", table:"AccessoryNames"), serialNumber: "00606", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Office Power Outlet whiteboard", table:"AccessoryNames"), serialNumber: "00607", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Office Power Outlet", table:"AccessoryNames"), serialNumber: "00608", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Hallway Power Outlet", table:"AccessoryNames"), serialNumber: "00609", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Bedroom Power Outlet bed right side", table:"AccessoryNames"), serialNumber: "00610", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Bedroom Power Outlet bed left side", table:"AccessoryNames"), serialNumber: "00611", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Bedroom Power Outlet TV", table:"AccessoryNames"), serialNumber: "00612", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        Accessory.Outlet(info: Service.Info(name:String(localized:"Landing Power Outlet", table:"AccessoryNames"), serialNumber: "00613", manufacturer: "Niko")) : PLCAccessoryDelegate(),
        
        // MARK: - Sprinkler
        Accessory.SmartSprinkler(info: Service.Info(name:String(localized:"Smart Sprinklers", table:"AccessoryNames"), serialNumber: "0702",manufacturer: "Hunter")) : PLCAccessoryDelegate(),
        
        // MARK: - Smart Lights Milight
        
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"Beam", table:"AccessoryNames"), serialNumber: "10000", manufacturer: "Milight"), type: .color, isDimmable: true) : MilightAccessoryDelegate(ipAddress:"192.168.0.52", zone: .zone01(name: String(localized:"Beam", table:"AccessoryNames"))),
        
        Accessory.Lightbulb(info: Service.Info(name:String(localized:"UFO", table:"AccessoryNames"), serialNumber: "10001", manufacturer: "Milight"), type: .color, isDimmable: true) : MilightAccessoryDelegate(ipAddress:"192.168.0.52", zone: .zone02(name: String(localized:"UFO", table:"AccessoryNames"))),
        
        
        // MARK: - T.V.s
        // Use 'InputSource'-selectors to switch channels instead
        Accessory.Television(info: Service.Info(name:String(localized:"TV", table:"AccessoryNames"), serialNumber: "20000", manufacturer: "Samsung"),
                             inputs: [
                                (String(localized: "Channel00", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel01", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel02", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel03", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel04", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel05", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel06", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel07", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel08", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel09", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel10", table: "TVChannelNames"), .hdmi),
                                (String(localized: "App01", table: "TVChannelNames"), .application),
                                (String(localized: "App02", table: "TVChannelNames"), .application),
                                (String(localized: "App03", table: "TVChannelNames"), .application),
                                (String(localized: "App04", table: "TVChannelNames"), .application)
                             ]) : TizenAccessoryDelegate(tvName:String(localized:"TV", table:"AccessoryNames"), macAddress: "F8:3F:51:2E:C5:F1", ipAddress: "192.168.0.50", port: 8002, deviceName: "HAPiNestServer"),
        
        Accessory.Television(info: Service.Info(name:String(localized:"TV Upstairs", table:"AccessoryNames"), serialNumber: "20001", manufacturer: "Samsung"),
                             
                             inputs: [
                                (String(localized: "Channel00", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel01", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel02", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel03", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel04", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel05", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel06", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel07", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel08", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel09", table: "TVChannelNames"), .hdmi),
                                (String(localized: "Channel10", table: "TVChannelNames"), .hdmi),
                                (String(localized: "App01", table: "TVChannelNames"), .application),
                                (String(localized: "App02", table: "TVChannelNames"), .application),
                                (String(localized: "App03", table: "TVChannelNames"), .application),
                                (String(localized: "App04", table: "TVChannelNames"), .application)
                             ]) : TizenAccessoryDelegate(tvName:String(localized:"TV Upstairs", table:"AccessoryNames"), macAddress: "7C:64:56:80:4E:90", ipAddress: "192.168.0.116", port: 8002, deviceName: "HAPiNestServer"),
        
        // MARK: - Other
        Accessory.ElectricCar(info: Service.Info(name: String(localized:"Electric Car", table:"AccessoryNames"), serialNumber: "30003", manufacturer: "Nissan")) : LeafAccessoryDelegate(leafProtocol: LeafProtocolV2())
        
        
        
        //                  (Accessory.init(info: Service.Info(name:String(localized:"Zonnepanelen", table:"AccessoryNames"), serialNumber: "30001", manufacturer: "SMA"),
        //                                   type: .other,
        //                                   services: [
        //                                    // TODO: - Insert a Service.EnergyMeter and Service.PowerMeter,
        //                                    // once it gets supported by Apples 'Home'-App
        //                                    .SwitchBase(characteristics:[.name("Opbrengst opvragen")] ),
        //                                   ] ),
        //                    YASDIDriver.InstallDrivers().first!
        //                    )
    ]
    
}

