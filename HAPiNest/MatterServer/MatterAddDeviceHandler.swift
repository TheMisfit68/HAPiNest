//
//  MatterAddDeviceHandler.swift
//  HAPiNest
//
//  Created by Jan Verrept on 27/11/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import MatterSupport

/// Development on hold for now until documentation for MatterSupport improves
class MyMatterAddDeviceExtensionRequestHandler: MatterAddDeviceExtensionRequestHandler {
    
//    override init() {
//        super.init()
//    }
//    
//    
//    // Override this method to return the rooms in the home.
//    override func rooms(in home: MatterAddDeviceRequest.Home?) async -> [MatterAddDeviceRequest.Room] {
//        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Received request to fetch rooms in home: \(String(describing: home))")
//        
//        
//        var rooms: [String] = ["Living Room", "Bedroom", "Office"];
//        return rooms.map { MatterAddDeviceRequest.Room(displayName: $0) }
//    }
//    
//    
//    // Override this method to commission the device.
//    override func commissionDevice(in home: MatterAddDeviceRequest.Home?, onboardingPayload: String, commissioningID: UUID) async throws {
//        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Received request to commission device in home \(String(describing: home)) using onboarding payload: \(onboardingPayload) and uuid: \(commissioningID)")
//        
//        
//        do {
//            // Use Matter framework APIs to pair the accessory to your application with the provided onboardingPayload.
//            os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Successfully paired accessory: \(String(describing: accessory))")
//        } catch {
//            os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Failed to pair accessory: \(String(describing: error))")
//            throw error
//        }
//    }
//    
//    
//    // Override this method to commission the device to your application.
//    override func configureDevice(named name: String, in room: MatterAddDeviceRequest.Room?) async {
//        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Received request to configure device with name \(name) in room: \(String(describing: room))")
//        
//        
//        // Configure the device with selected attributes.
//        let accessory = <Your_Ecosystem_Accessory_Object>
//        accessory.name = name
//        accessory.roomName = room?.displayName ?? "Room Name Not Available"
//    }
//    
//    
//    // Override this method to validate the device's credentials.
//    override func validateDeviceCredential(_ deviceCredential: MatterAddDeviceExtensionRequestHandler.DeviceCredential) async throws {
//        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Received request to validate device credential: \(String(describing: deviceCredential))")
//        
//        
//        // Performs verification and attestation checks.
//        var isValid = false
//        
//        
//        if !isValid {
//            os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Rejecting device credential: \(String(describing: deviceCredential))")
//            throw "Failed to validate device credentials"
//        } else {
//            os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Confirming device credential: \(String(describing: deviceCredential))")
//        }
//    }
//    
//    
//    // Override this method to select a specific Wi-Fi network.
//    override func selectWiFiNetwork(from wifiScanResults: [MatterAddDeviceExtensionRequestHandler.WiFiScanResult]) async throws -> MatterAddDeviceExtensionRequestHandler.WiFiNetworkAssociation {
//        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Received WiFi scan results: \(String(describing: wifiScanResults))")
//        
//        // If your application would like to specify a nondefault Wi-Fi network.
//        var shouldSelectNetwork = true
//        
//        if shouldSelectNetwork {
//            // Return the SSID and credentials known to your application.
//            os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Selecting WiFi network with SSID: \(String(describing: ssid)) Credentials: \(String(describing: credentials))")
//            return .network(ssid: ssid, credentials: credentials)
//        } else {
//            os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Selecting default WiFi network")
//            return .defaultSystemNetwork
//        }
//    }
//    
//    
//    // Override this method to select a specific Thread network.
//    override func selectThreadNetwork(from threadScanResults: [MatterAddDeviceExtensionRequestHandler.ThreadScanResult]) async throws -> MatterAddDeviceExtensionRequestHandler.ThreadNetworkAssociation {
//        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Received Thread scan results: \(String(describing: threadScanResults))")
//        
//        // If your application would like to specify a nondefault Thread network.
//        var shouldSelectNetwork = true
//        
//        if shouldSelectNetwork {
//            // Return `extendedPANID` of the Thread network known to your application.
//            os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Selecting Thread network with extendedPANID: \(String(describing: extendedPANID))")
//            return .network(extendedPANID: extendedPANID)
//        } else {
//            os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG,"Selecting default Thread network")
//            return .defaultSystemNetwork
//        }
//    }
    
    
}
