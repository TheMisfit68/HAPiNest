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
    
    var pulsTimer:DigitalTimer { get }
    var outputAsPuls:Bool { get }
    
}
