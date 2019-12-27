//
//  CustomAccessoryTypes.swift
//  HAPiNest
//
//  Created by Jan Verrept on 26/12/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//
import HAP

class InverterAccessory: Accessory {
    let service = InverterService()
    init(info: Service.Info) {
        super.init(info: info, type: .other, services: [service])
    }
}
class InverterService: Service {
    public let status = GenericCharacteristic<Bool>(
        type: .statusActive,
        value: false)
    public let currentYeld = GenericCharacteristic<Double>(
           type: .powerState,
           value: 0.0,
           permissions: [.read, .events])
    public let dailyYeld = GenericCharacteristic<Double>(
        type: .powerState,
        value: 0.0,
        permissions: [.read, .events])
    public let yearlyYeld = GenericCharacteristic<Double>(
           type: .powerState,
           value: 0.0,
           permissions: [.read, .events])
    init() {
        super.init(type: .outlet, characteristics: [
            AnyCharacteristic(status),
            AnyCharacteristic(currentYeld),
            AnyCharacteristic(dailyYeld),
            AnyCharacteristic(yearlyYeld)
        ])
    }
}
//
//class PowerBankAccessory: Accessory {
//    let service = PowerBankService()
//    init(info: Service.Info) {
//        super.init(info: info, type: .outlet, services: [service])
//    }
//}
//class PowerBankService: Service {
//    public let on = GenericCharacteristic<Bool>(
//        type: .on,
//        value: false)
//    public let inUse = GenericCharacteristic<Bool>(
//        type: .outletInUse,
//        value: true,
//        permissions: [.read, .events])
//    public let batteryLevel = GenericCharacteristic<Double>(
//        type: .batteryLevel,
//        value: 100,
//        permissions: [.read, .events])
//
//    init() {
//        super.init(type: .outlet, characteristics: [
//            AnyCharacteristic(on),
//            AnyCharacteristic(inUse),
//            AnyCharacteristic(batteryLevel)
//        ])
//    }
//}
