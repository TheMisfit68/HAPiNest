//
//  Enums.swift
//  HAPiNest
//
//  Created by Jan Verrept on 05/01/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import HAP

public extension Enums {
	
	enum ProgramMode: UInt8, CharacteristicValueType {
		case noProgramsScheduled = 0
		case programsScheduled = 1
		case manualOverride = 2
	}
	
	enum InUse: UInt8, CharacteristicValueType {
		case notInUse = 0
		case inUse = 1
	}
	
}
