//
//  DashboardView.swift
//
//  Created by Jan Verrept on 04/12/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import SwiftUI
import SoftPLC
struct DashboardView: View {
	
	let serverView:HomeKitServerView
	let plcView:SoftPLCView
	// TODO: - Implement Inverter Display again
	// let inverterView:

	var body: some View {
		
		TabView {
			
			serverView
				.tabItem {
					Label("Homekit Server", systemImage:"server.rack")
				}
			
			//            if (inverterViewVisible){
			//            SMAInverter.OnlineInverters.first?.display.frame(width: nil, height: 120, alignment: .center)
			//                .tabItem {
			//                    		Label("SolarPanels", systemImage:"sun.max")
			//                }
			//            }
			
			plcView
				.tabItem {
					Label("PLC", systemImage:"play.circle")
				}.background(Color.Neumorphic.main)
			
			
		}
	}
}

#Preview {
    DashboardView.preview
}
