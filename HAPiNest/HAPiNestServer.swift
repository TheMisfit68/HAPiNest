//
//  HAPiNestServer.swift
//  HAPiNestServer
//
//  Created by Jan Verrept on 08/11/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import Foundation
import HAP
import Darwin

import AppleScriptDriver
import SiriDriver
import MilightDriver


// JUST FOR TESTING PURPOSES!!
let testDriver =  MilightDriverV6(ipAddress: "192.168.0.52")
let testSiri = SiriDriver(language: .flemish)
let testScript = AppleScriptDriver()
