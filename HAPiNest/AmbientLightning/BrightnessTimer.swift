//
//  BrightnessTimer.swift
//  HAPiNest
//
//  Created by Jan Verrept on 12/12/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import SoftPLC

protocol DimmedLight:AnyObject{
	
    var brightness: Int? { get set }
	var brightnessTimer:BrightnessTimer!{get set}
	
}

// Foundation.Timer is a class cluster and it's not meant to be subclassed directly, so
// use a helper class a.k.a. composition instead of inheritance.
class BrightnessTimer {

    weak var dimmer: DimmedLight?
	
    // Public property for time to make a 100% change
	public var timeFor100percentChange: TimeInterval = 5.0 // Default to 5 seconds for a full range change
	private var timer: Timer?

    var targetBrightness: Int? {
        didSet {
            if targetBrightness == nil {
                stop()
            } else if targetBrightness != oldValue {
                adjustBrightness()
            }
        }
    }
    
    var brightness: Int {
        get { return dimmer?.brightness ?? 0}
        set { dimmer?.brightness = newValue }
    }
    
    init(dimmer: DimmedLight) {
        self.dimmer = dimmer
    }
    
    private func adjustBrightness() {
        // Interval for 1% change
        let intervalForOnePercentChange = timeFor100percentChange / 100
        
        timer?.invalidate() // Invalidate any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: intervalForOnePercentChange, repeats: true) { [weak self] _ in
            guard let self = self, let targetBrightness = self.targetBrightness else { return }
            
#warning("DEBUGPRINT") // TODO: - remove temp print statement
			print("🐞\tI'm dimming")

            // Apply a small 1% adjustment at the time in either direction
			let onePercentAdjustment:Int = (targetBrightness >= self.brightness) ? 1 : -1
			
			// Apply the adjustment only if it does not overshoot the target brightness
			if (onePercentAdjustment == 1) && (self.brightness+onePercentAdjustment >= targetBrightness) ||
				(onePercentAdjustment == -1) && (self.brightness+onePercentAdjustment <= targetBrightness) {
				self.brightness = targetBrightness
				self.stop()
			} else {
				self.brightness += onePercentAdjustment
			}
            
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
