//
//  PowerInverter.swift
//  HAPiNest
//
//  Created by Jan Verrept on 26/12/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//
import Foundation
import HAP

//extension Accessory{
//    open class PowerInverter: Accessory {
//        public let powerMeter = Service.PowerMeter()
//
//        public init(info: Service.Info) {
//            super.init(info: info, type: .other, services: [powerMeter])
//        }
//    }
//}
//
//extension Service {
//    open class PowerMeter: PowerMeterBase {
//    }
//}
//
//open class PowerMeterBase: Service {
//    // Required Characteristics
//    public let power:GenericCharacteristic<Double>
//
//    // Optional Characteristics
//    public let powerState:GenericCharacteristic<Bool>?
//    public let energyDaily: GenericCharacteristic<Double>?
//    public let energyTotal: GenericCharacteristic<Double>?
//}
//
//    public init(characteristics: [AnyCharacteristic] = []) {
//        var unwrapped = characteristics.map { $0.wrapped }
//        power = getOrCreateAppend(
//                    type: .currentTemperature,
//                    characteristics: &unwrapped,
//                    generator: { PredefinedCharacteristic.currentTemperature() })
//                name = get(type: .name, characteristics: unwrapped)
//                powerState = get(type: .statusActive, characteristics: unwrapped)
//                energyDaily = get(type: .statusFault, characteristics: unwrapped)
//                energyTotal = get(type: .statusLowBattery, characteristics: unwrapped)
//                statusTampered = get(type: .statusTampered, characteristics: unwrapped)
//                super.init(type: .temperatureSensor, characteristics: unwrapped)
//            }
//
//
//
//    init() {
//        var unwrapped = characteristics.map { $0.wrapped }
//
//        let characteristics = [
//            AnyCharacteristic(powerState),
//            AnyCharacteristic(power),
//            AnyCharacteristic(energyDaily),
//            AnyCharacteristic(energyTotal)
//        ]
//        super.init(type: .powerMeterService, characteristics: characteristics)
//    }
//}
//


class PowerBankAccessory: Accessory {
    let service = PowerBankService()
    init(info: Service.Info) {
        super.init(info: info, type: .outlet, services: [service])
    }
}
class PowerBankService: Service {
   
    public let power = GenericCharacteristic<Double>(
        type: .power,
        value: 100,
        permissions: [.read, .events])

    init() {
        super.init(type: .powerMeterService, characteristics: [
            AnyCharacteristic(power)
        ])
    }
}
