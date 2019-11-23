//
//  Bridge.swift
//  HAPiNest
//
//  Created by Jan Verrept on 17/11/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import JVCocoa
import AppleScriptDriver
import SiriDriver
import MilightDriver

typealias Bridge = Device
typealias BridgeDelegate = DeviceDelegate

extension Bridge{
    
    public func printPairingInstructions(){
        if self.isPaired {
            print()
            print("The bridge is paired, unpair using your iPhone.")
            print()
        } else {
            print()
            print("Scan the following QR code using your iPhone to pair this bridge:")
            print()
            print(self.setupQRCode.asText)
            print()
        }
    }
    
}

class MainBridgeDelegate: BridgeDelegate {
    
    let milightDriver =  MilightDriverV6(ipAddress: "192.168.0.52")
    let siriDriver = SiriDriver(language: .flemish)
    let appleScriptDriver = AppleScriptDriver()
    
    func didRequestIdentificationOf(_ accessory: Accessory) {
        JVDebugger.shared.log(debugLevel: .Info,"Requested identification "
            + "of accessory \(String(describing: accessory.info.name.value ?? ""))")
    }
    
    func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                           ofService service: Service,
                           ofAccessory accessory: Accessory,
                           didChangeValue newValue: T?) {
        JVDebugger.shared.log(debugLevel: .Info, "Characteristic \(characteristic) "
            + "in service \(service.type) "
            + "of accessory \(accessory.info.name.value ?? "") "
            + "did change: \(String(describing: newValue))")
        handleCharacteristicChange(accessory, service, characteristic, newValue)
    }
    
    func characteristicListenerDidSubscribe(_ accessory: Accessory,
                                            service: Service,
                                            characteristic: AnyCharacteristic) {
        JVDebugger.shared.log(debugLevel: .Info, "Characteristic \(characteristic) "
            + "in service \(service.type) "
            + "of accessory \(accessory.info.name.value ?? "") "
            + "got a subscriber")
    }
    
    func characteristicListenerDidUnsubscribe(_ accessory: Accessory,
                                              service: Service,
                                              characteristic: AnyCharacteristic) {
        JVDebugger.shared.log(debugLevel: .Info, "Characteristic \(characteristic) "
            + "in service \(service.type) "
            + "of accessory \(accessory.info.name.value ?? "") "
            + "lost a subscriber")
    }
    
    func didChangePairingState(from: PairingState, to: PairingState) {
        if to == .notPaired {
            HomeKitServer.shared.bridge.printPairingInstructions()
        }
    }
    
    
    func handleCharacteristicChange<T>(
        
        _ accessory: Accessory,
        _ service: Service,
        _ characteristic: GenericCharacteristic<T>,
        _ value:T?
    ){
        
        let accessoryName = accessory.info.name.value ?? ""
        let driverToUse:AnyObject?
        var driverParameters:[String:Any] = [:]
        
        switch accessoryName {
        case "Balk":
            driverToUse = milightDriver
            driverParameters["zone"] = MilightZone.zone01
        case "UFO":
            driverToUse = milightDriver
            driverParameters["zone"] = MilightZone.zone02
        case "W.C.":
            driverToUse = milightDriver
            driverParameters["zone"] = MilightZone.zone03
        default:
            driverToUse =  nil
        }
        
        switch driverToUse {
            
        case let miligthDriver as MilightDriver:
            
            let zone = (driverParameters["zone"] as! MilightZone)
            if characteristic is HAP.GenericCharacteristic<Swift.Bool>{
                let action = (characteristic.value as! Bool) ? MilightAction.on : MilightAction.off
                miligthDriver.executeCommand(mode: .rgbwwcw, action: action, zone: zone)
            }else if characteristic is HAP.GenericCharacteristic<Swift.Int>{
                let brightness = Int(characteristic.value as! Int)
                miligthDriver.executeCommand(mode: .rgbwwcw, action: .brightNess,value: brightness, zone: zone)
            }else if characteristic is HAP.GenericCharacteristic<Swift.Float>{
                let degrees = Int(characteristic.value as! Float)
                if (degrees > 0){
                    miligthDriver.executeCommand(mode: .rgbwwcw, action: .hue, value: degrees, zone: zone)
                }else{
                    JVDebugger.shared.log(debugLevel: .Info, "Switching to dedicated whitemode a.k.a cold white)")
                    miligthDriver.executeCommand(mode: .rgbwwcw, action: .temperature, value:100,  zone: zone)
                }
            }
            
        case let siriDriver as SiriDriver:
            print("Didn't implement this driver yet")
        case let appleSciptDriver as AppleScriptDriver:
            print("Didn't implement this driver yet")
        default:
            JVDebugger.shared.log(debugLevel: .Warning, "Couldn't find driver for \(accessoryName)")
        }
        
    }
    
    
}

