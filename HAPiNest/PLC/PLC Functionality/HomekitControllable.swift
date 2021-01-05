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

protocol HomekitControllable:Parameterizable{
    
    var service:HAP.Service {get}
    var homeKitEvents:[Accessory:Any] { get set }
    var homekitFeedbacks:[CharacteristicType:Any] { get set }
    
    func parseNewHomeKitEvents()
    func feedbackHomeKitState()
    
}

 
