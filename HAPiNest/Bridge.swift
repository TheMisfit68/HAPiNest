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

// Device its not declared Open bij te developer of HAP
// Therefore it can't be subclassed and
// Bridge is a just wrapper around it

class Bridge:DeviceDelegate{
        
    public let device:Device
    
    public var setupCode: String {
        return device.setupCode
    }
    public var setupQRCode: QRCode {
        return device.setupQRCode
    }
    public var isPaired:Bool{
        device.isPaired
    }
    
   
    
    private let serialNumber = "00001"
    private let configFile = FileStorage(filename: "configuration.json")
    private var accessorryDelegates:[String:AccessoryDelegate] = [:]
    
    public init(name:String, setupCode:String) {
        
        device = Device(
            bridgeInfo: Service.Info(name: name, serialNumber: serialNumber),
            setupCode: Device.SetupCode(stringLiteral: setupCode),
            storage: configFile,
            accessories: [])
        device.delegate = self
        
    }
    
    public func addDriver(_ driver:AccessoryDelegate, withAcccesories acccesories:[Accessory]){

        device.addAccessories(acccesories)
        acccesories.forEach{ accessory in
            if let accessoryName = accessory.info.name.value{
                accessorryDelegates[accessoryName] = driver
            }
        }
        
    }
    
    // MARK: - Pairing Info

    public func printPairingInstructions(){
        if isPaired {
            print()
            JVDebugger.shared.log(debugLevel: .Succes, "The bridge is paired, unpair using your iPhone.")
            print()
        } else {
            print()
            JVDebugger.shared.log(debugLevel: .Info, "Scan the following QR code using your iPhone to pair this bridge:")
            print()
            print(setupQRCode.asText)
            print(setupCode)
            print()
        }
    }
    
    public func resetPairingInfo(){
        JVDebugger.shared.log(debugLevel: .Info, "Dropping all pairings, keys")
        try? configFile.write(Data())
    }
    
  
    
    
    // MARK: - DeviceDelegate functions

    func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                           ofService service: Service,
                           ofAccessory accessory: Accessory,
                           didChangeValue newValue: T?) {
        JVDebugger.shared.log(debugLevel: .Info, "Characteristic \(characteristic) "
                                + "in service \(service.type) "
                                + "of accessory \(accessory.info.name.value ?? "") "
                                + "did change: \(String(describing: newValue))")
        
        if let accessoryName = accessory.info.name.value{
            accessorryDelegates[accessoryName]?.handleCharacteristicChange(accessory, service, characteristic, newValue)
        }
    }
    
    func didRequestIdentificationOf(_ accessory: Accessory) {
        JVDebugger.shared.log(debugLevel: .Info,"Requested identification "
                                + "of accessory \(String(describing: accessory.info.name.value ?? ""))")
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
            printPairingInstructions()
        }
    }
    
}
