//
//  Accessory.swift
//  HAPiNest
//
//  Created by Jan Verrept on 08/01/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import SoftPLC
import HAP
import JVCocoa

extension HAP.Accessory{
	
    public var name:String {
		info.name.value!
	}
	
}

