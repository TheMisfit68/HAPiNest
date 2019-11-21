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
        
    func didRequestIdentificationOf(_ accessory: Accessory) {
        JVDebugger.shared.log(debugLevel: .Info,"Requested identification "
            + "of accessory \(String(describing: accessory.info.name.value ?? ""))")
        JVDebugger.shared.logThisMethod(type: self)
    }
    
    func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                           ofService service: Service,
                           ofAccessory accessory: Accessory,
                           didChangeValue newValue: T?) {
        JVDebugger.shared.log(debugLevel: .Info, "Characteristic \(characteristic) "
            + "in service \(service.type) "
            + "of accessory \(accessory.info.name.value ?? "") "
            + "did change: \(String(describing: newValue))")
        JVDebugger.shared.logThisMethod(type: self)
    }
    
    func characteristicListenerDidSubscribe(_ accessory: Accessory,
                                            service: Service,
                                            characteristic: AnyCharacteristic) {
        JVDebugger.shared.log(debugLevel: .Info, "Characteristic \(characteristic) "
            + "in service \(service.type) "
            + "of accessory \(accessory.info.name.value ?? "") "
            + "got a subscriber")
        JVDebugger.shared.logThisMethod(type: self)
    }
    
    func characteristicListenerDidUnsubscribe(_ accessory: Accessory,
                                              service: Service,
                                              characteristic: AnyCharacteristic) {
        JVDebugger.shared.log(debugLevel: .Info, "Characteristic \(characteristic) "
            + "in service \(service.type) "
            + "of accessory \(accessory.info.name.value ?? "") "
            + "lost a subscriber")
        JVDebugger.shared.logThisMethod(type: self)
    }
    
    func didChangePairingState(from: PairingState, to: PairingState) {
        if to == .notPaired {
            HomeKitServer.shared.bridge.printPairingInstructions()
        }
        JVDebugger.shared.logThisMethod(type: self)
        
    }
    
    
    func handleCharacteristicChange(
                
        accessory: Accessory,
        service: Service,
        characteristic: AnyCharacteristic){
        
        let accessoryName = accessory.info.name.value ?? ""
        let driverToUse = driversToUse[accessoryName]
        
//        switch driverToUse {
//        case let driver as MilightDriver:
//            let test = driver.executeCommand(mode: .rgbwwcw, action: .effect, value:9, zone: .all)
//        case let driver as SiriDriver:
//        case let driver as AppleScriptDriver:
//        default:
//            JVDebugger.shared.log(debugLevel: .Warning, "Couldn't find driver for \(accessoryName)")
//        }
        
        
    }
}
