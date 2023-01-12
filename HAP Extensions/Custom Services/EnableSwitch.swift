//
//  EnableSwitch.swift
//  HAPiNest
//
//  Created by Jan Verrept on 01/01/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import HAP

extension Service.Switch {
	
	open class EnableSwitch: Service {
		public let enabled:GenericCharacteristic<Bool>
		
		init() {
			enabled = GenericCharacteristic<Bool>(
				type: .statusActive,
				value: false)
			super.init(type: .switch, characteristics: [AnyCharacteristic(enabled)])
		}
	}
	
}
