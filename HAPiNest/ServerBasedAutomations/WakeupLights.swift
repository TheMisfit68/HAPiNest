//
//  BrightnessTimer.swift
//  HAPiNest
//
//  Created by Jan Verrept on 12/12/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import SoftPLC

class WakeupLights:PLCClass{ 
	 
	override init() {
		let bedRoomLightKey = String(localized:"Bedroom Light", table:"AccessoryNames")
		let bedRoomLight = MainConfiguration.PLC.PLCobjects[bedRoomLightKey] as! DimmableLight
	}
	
}

// Foundation.Timer is a class cluster and it's not meant to be subclassed directly, so
// use a helper class a.k.a. composition instead of inheritance.
class BrightnessTimer {
	
	// Public property for time to make a 100% change
	private var timer: Timer?
	
	private func adjust(brightness:inout Int?, to targetBrightness:Int?, over totalTime:TimeInterval = 5.0){
		
		if let previousBrightness = brightness, let targetBrightness = targetBrightness, brightness != targetBrightness {
			
			// Interval for 1% change
			let intervalForOnePercentChange = totalTime/100
			
			var newBrightness:Int = previousBrightness
			
			timer?.invalidate() // Invalidate any existing timer
			timer = Timer.scheduledTimer(withTimeInterval: intervalForOnePercentChange, repeats: true) { [weak self] _ in
				guard let self = self else { return }
				
				// Apply a small 1% adjustment at the time in either direction
				// ensuring the result doesn't overshoot the targetBrighttness
				if (targetBrightness > previousBrightness){
					if (previousBrightness+1 >= targetBrightness){
						newBrightness = targetBrightness
						self.stop()
					}else{
						newBrightness += 1
					}
				}else if (targetBrightness < previousBrightness) {
					if (previousBrightness-1 <= targetBrightness) {
						newBrightness = targetBrightness
						self.stop()
					}else{
						newBrightness -= 1
					}
				}else {
					self.stop()
				}
			}
			brightness = newBrightness
			
		}else{
			stop()
		}
	}
	
	func stop() {
		timer?.invalidate()
		timer = nil
	}
	
}
