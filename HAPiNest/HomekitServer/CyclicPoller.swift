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

public enum Status:Equatable{
	case running
	case stopped
}

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
		
		let nonPLCaccessories = MainConfiguration.HomeKit.Accessories.map{$0.1}.filter{!($0 is PLCClass)}
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

