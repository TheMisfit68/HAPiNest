//
//  StatelessProgrammableSwitch.swift
//  HAPiNest
//
//  Created by Jan Verrept on 17/12/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//
import Foundation
import HAP

#warning("TODO") // TODO: - Create a pull request to get this implemented by HAP itself
extension HAP.Accessory {
	open class ProgrammableSwitch: Accessory {
		public let primaryService:Service.StatelessProgrammableSwitch = Service.StatelessProgrammableSwitch()
		
		public init(info: Service.Info, additionalServices: [Service] = []) {
			super.init(info: info, type: .programmableSwitch, services: [primaryService] + additionalServices)
		}
	}
}

