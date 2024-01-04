    //
    //  Bridge.swift
    //  HAPiNest
    //
    //  Created by Jan Verrept on 17/11/2019.
    //  Copyright © 2019 Jan Verrept. All rights reserved.
    //

import Foundation
import JVSwift
import OSLog
import HAP
import SoftPLC


typealias Bridge = Device

extension Bridge{
    
    static let serialNumber = "00001"
    static var configFile:Storage!
    
    convenience init(name:String, setupCode:String, accessories:[HAP.Accessory], configfileName:String) {
                
        // Use the Application support folder to hold the HAP-configuration-data
        let fileManager = FileManager.default
        if let hapSupportDir = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("HAP"){
            
            fileManager.checkForDirectory(hapSupportDir,createIfNeeded: true)
            let configFile = hapSupportDir.appendingPathComponent(configfileName)
            Self.configFile = FileStorage(filename:configFile.path)
            
                // Create an Alias for easy access
            let homeDir = FileManager.default.homeDirectoryForCurrentUser
            let aliasURL = homeDir.appendingPathComponent("HAP-Data")
            if !fileManager.fileExists(atPath: aliasURL.path){
                fileManager.createAlias(from: hapSupportDir, at: aliasURL)
            }
            
        }
        
        self.init(
            bridgeInfo: Service.Info(name: name, serialNumber: Self.serialNumber),
            setupCode: Device.SetupCode(stringLiteral: setupCode),
            storage: Self.configFile,
            accessories: accessories
        )
        
        showPairingInstructions()
        
        // Set the delegate for the bridge itself and for the individual accessories
        delegate = self
        MainConfiguration.Accessories.forEach{ accessory, accessoryDelegate in
            accessory.delegate = accessoryDelegate
        }
    }
    
    // MARK: - Pairing Info
    
    public func showPairingInstructions(){
        let logger = Logger(subsystem: "be.oneclick.HAPiNest", category: "Bridge Pairing")
        if isPaired {
            logger.info("✅\tThe bridge is paired, unpair using your iPhone.")
        } else {
            logger.info(
                    """
                    Scan the following QR code using your iPhone to pair this bridge:
                                    
                    \(self.setupQRCode.asText, privacy: .public)
                    
                    Or enter the corresponding setup-code:
                    \(self.setupCode,privacy: .public)
                    """
            )
        }
    }
    
    public func resetPairingInfo(){
        let logger = Logger(subsystem: "be.oneclick.HAPiNest", category: "Bridge Pairing")
        logger.info("Dropping all pairings, keys")
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
