//
//  PulsOperatedCircuit.swift
//  HAPiNest
//
//  Created by Jan Verrept on 26/12/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import Foundation
import SoftPLC

protocol PulsOperatedCircuit{
    
    associatedtype DigitalTimerType
    
    var pulsTimer:DigitalTimerType { get }
    var puls:Bool { get }
    
}
