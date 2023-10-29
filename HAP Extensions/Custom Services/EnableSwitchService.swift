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
	
    class EnableSwitch: Service.Switch{
        
        // MARK: - Required Characteristics
        
        // Simply sync the buttons enabled-characteristic with its primary powerstate-characterisic
        public var enabled:GenericCharacteristic<Enums.Active>{
            GenericCharacteristic(type:.active, value: (self.powerState.value ?? false) ? Enums.Active.active : Enums.Active.inactive)
        }
		
		init() {
            super.init(characteristics: [.name(String(localized:"Enable",table: "ServiceNames"))] )
		}
                
	}
	
    
}
