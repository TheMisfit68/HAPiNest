//
//  CyclicPoller.swift
//  HAPiNest
//
//  Created by Jan Verrept on 08/08/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import Foundation
import JVCocoa
import SoftPLC

// Any object that can be polled for changes in a timely matter
protocol CyclicPollable{
    func pollCycle()
}

public enum Status:Equatable{
	case running
	case stopped
}

/// Start an extra background cycle indepedent of the PLCs backroundCycle
/// (to poll for hardware changes on behalf of acessoryDelegates that are not PLC-based)
class CyclicPoller{
	
	private let timeInterval: TimeInterval
	
	init(timeInterval: TimeInterval){
		self.timeInterval = timeInterval
	}
	
	private lazy var backgroundTimer: DispatchSourceTimer = {
		let timer = DispatchSource.makeTimerSource()
		timer.schedule(deadline: .now(), repeating:self.timeInterval)
		timer.setEventHandler(handler: { [weak self] in
			
			self?.pollCycle()
			
		})
		return timer
	}()
	
    private func pollCycle(){
		
        let nonPLCaccessories = MainConfiguration.Accessories.values.filter{ !($0 is PLCAccessoryDelegate) }
		nonPLCaccessories.forEach {
            ($0 as? (any CyclicPollable))?.pollCycle()
		}
        
	}
	
	// MARK: - Cycle Control
	var status:Status = .stopped
	
	func run() {
		if status != .running {
			status = .running
			backgroundTimer.resume()
		}
	}
	
	func stop() {
		if status == .running{
			status = .stopped
			backgroundTimer.suspend()
		}
	}
	
}

