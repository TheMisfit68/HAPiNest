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
	
    open class EnableSwitch: Service.Switch {
		
        public let enabled:GenericCharacteristic<Enums.Active> = GenericCharacteristic<Enums.Active>(type: .active, value: .inactive)
		
		init() {
            super.init(characteristics: [.name(String(localized:"Enable")),AnyCharacteristic(enabled)])
		}
                
	}
	
}
