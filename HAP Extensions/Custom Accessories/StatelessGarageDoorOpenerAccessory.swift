//
//  StatelessGarageDoorOpenerAccessory.swift
//  HAPiNest
//
//  Created by Jan Verrept on 11/01/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import Foundation
import HAP

extension Accessory.GarageDoorOpener {
	
    class StatelessGarageDoorOpener:Accessory{
        
        let primaryService:Service.Switch = Service.Switch(characteristics: [.name(String(localized:"Switch on",table: "ServiceNames"))])
        
        init(info: Service.Info) {
            super.init(info: info, type: .garageDoorOpener, services: [primaryService])
        }
        
    }
    
}

