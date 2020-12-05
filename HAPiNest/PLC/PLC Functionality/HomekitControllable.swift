//
//  HomekitControllable.swift
//  HAPiNest
//
//  Created by Jan Verrept on 29/08/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import SoftPLC
import JVCocoa


extension PLCclass{

    enum HomekitParameterName{
        case powerState
        case brightness
        case setPoint
        case unKnown
    }
    
}


protocol HomekitControllable{
    
    var homekitParameters:[PLCclass.HomekitParameterName:Any] { get set }
    
}
