//
//  StatelessProgrammableSwitch.swift
//  HAPiNest
//
//  Created by Jan Verrept on 17/12/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//
import Foundation
import HAP

#warning("TODO") // TODO: - Create a pull request to get this implemented into HAP itself
extension Accessory {
	
	open class StatelessProgrammableSwitch: Accessory {
		public let primaryService:Service.StatelessProgrammableSwitch = Service.StatelessProgrammableSwitch(characteristics: [.name(String(localized: "Function key",table: "ServiceNames"))])
		
		public init(info: Service.Info, additionalServices: [Service] = []) {
			super.init(info: info, type: .programmableSwitch, services: [primaryService] + additionalServices)
		}
	}
	
}

