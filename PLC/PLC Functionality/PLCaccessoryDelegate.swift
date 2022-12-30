//
//  PLCaccessoryDelegate.swift
//  HAPiNest
//
//  Created by Jan Verrept on 02/11/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import Foundation
import SoftPLC

typealias PLCaccessoryDelegate = PLCClass & Parameterizable & CyclicRunnable & AccessoryDelegate & AccessorySource
