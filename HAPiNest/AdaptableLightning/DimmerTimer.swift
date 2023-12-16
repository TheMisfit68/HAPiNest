//
//  DimmerTimer.swift
//  HAPiNest
//
//  Created by Jan Verrept on 12/12/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import JVCocoa

protocol Dimmer:AnyObject{
    var brightness: Float { get set }
}

// Foundation.Timer is a class cluster and it's not meant to be subclassed directly, so
// use a helper class a.k.a. composition instead of inheritance.
class DimmerTimer {
    weak var dimmer: Dimmer?
    private var timer: Timer?
    
    // Public property for time to make a 100% change
    var timeForFullChange: TimeInterval = 10.0 // Default to 10 seconds for a full range change
    
    var targetBrightness: Float? {
        didSet {
            if targetBrightness == nil {
                stop()
            } else if targetBrightness != oldValue {
                adjustBrightness()
            }
        }
    }
    
    var brightness: Float {
        get { return dimmer?.brightness ?? 0.0 }
        set { dimmer?.brightness = newValue }
    }
    
    init(dimmer: Dimmer) {
        self.dimmer = dimmer
    }
    
    private func adjustBrightness() {
        // Interval for 1% change
        let intervalForOnePercentChange = timeForFullChange / 100
        
        timer?.invalidate() // Invalidate any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: intervalForOnePercentChange, repeats: true) { [weak self] _ in
            guard let self = self, let targetBrightness = self.targetBrightness else { return }
            
            // Apply a small 1% adjustment at the time in either direction
            let onePercentAdjustment:Float = (targetBrightness >= self.brightness) ? 0.01 : -0.01
            if (self.brightness+onePercentAdjustment) >= targetBrightness || (self.brightness+onePercentAdjustment) <= targetBrightness{
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
