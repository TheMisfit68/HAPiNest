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
            Debugger.shared.log(debugLevel: .Succes, "The bridge is paired, unpair using your iPhone.")
            print()
        } else {
            print()
            Debugger.shared.log(debugLevel: .Native(logType:.info), "Scan the following QR code using your iPhone to pair this bridge:")
            print()
            print(setupQRCode.asText)
            print(setupCode)
            print()
        }
    }
    
    public func resetPairingInfo(){
        Debugger.shared.log(debugLevel: .Native(logType:.info), "Dropping all pairings, keys")
        try? configFile.write(Data())
    }
    
    
    
    
    // MARK: - DeviceDelegate functions
    func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                           ofService service: Service,
                           ofAccessory accessory: Accessory,
                           didChangeValue newValue: T?) {
        let accessoryName = accessory.info.name.value ?? ""
        let characteristicName = characteristic.description ?? ""
        let valueString = newValue != nil ? "\(newValue!)" : "nil"
        Debugger.shared.log(debugLevel: .Native(logType:.info), "Accessory \(accessoryName): Characteristic '\(characteristicName)' did change to \(valueString)")
        
        if let accessoryDelegate = accessorryDelegates[accessoryName]{
            accessoryDelegate.handleCharacteristicChange(accessory, service, characteristic, newValue)
        }
    }
    
    func didRequestIdentificationOf(_ accessory: Accessory) {

    }
    
    func characteristicListenerDidSubscribe(_ accessory: Accessory,
                                            service: Service,
                                            characteristic: AnyCharacteristic) {
    }
    
    func characteristicListenerDidUnsubscribe(_ accessory: Accessory,
                                              service: Service,
                                              characteristic: AnyCharacteristic) {
    }
    
    func didChangePairingState(from: PairingState, to: PairingState) {
        if to == .notPaired {
            printPairingInstructions()
        }
    }
    
}
