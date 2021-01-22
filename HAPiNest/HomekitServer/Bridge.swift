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


typealias Bridge = Device

extension Bridge{
    
    static let serialNumber = "00001"
    static let configFile =  FileStorage(filename: "configuration.json")
    
    convenience init(name:String, setupCode:String, accessories:[HAP.Accessory]) {
        
        self.init(
            bridgeInfo: Service.Info(name: name, serialNumber: Self.serialNumber),
            setupCode: Device.SetupCode(stringLiteral: setupCode),
            storage: Self.configFile,
            accessories: accessories)
        printPairingInstructions()
        delegate = self
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
        try? Self.configFile.write(Data())
    }
	
	subscript(accessoryName: String) -> Accessory?{
		return accessories.first(where: {$0.info.name.value == accessoryName })
	}
	
    public func removeAccessoryWith(SerialNumbers:[String]){
        
        let unwantedAccessories = accessories.filter{SerialNumbers.contains($0.info.serialNumber.value!)}
        removeAccessories(unwantedAccessories, andForgetSerialNumbers: true)
        
    }
    
}


// MARK: - BridgeDelegate

typealias BridgeDelegate = DeviceDelegate

extension Bridge:BridgeDelegate{
    
    func accessoryDelegateFor(accesoryNamed accessoryName:String)->AccessoryDelegate?{
        return MainConfiguration.HomeKit.Accessories.first(where: {$0.0.info.name.value! == accessoryName} )?.1
    }
    
    public func characteristic<T>(
        _ characteristic: GenericCharacteristic<T>,
        ofService: Service,
        ofAccessory: Accessory,
        didChangeValue: T?){
        
        let accessoryName = ofAccessory.info.name.value!
        Debugger.shared.log(debugLevel: .Event, "Value '\(characteristic.description ?? "")' of '\(accessoryName)' changed to \(didChangeValue ?? "" as! T)")
        
        // Forward all characteristic changes to the corresponding delegate
        accessoryDelegateFor(accesoryNamed:accessoryName)?.handleCharacteristicChange(accessory:ofAccessory, service: ofService, characteristic: characteristic, to: didChangeValue)
    }
    
}
