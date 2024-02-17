//
//  PreferencesView.swift
//  HAPiNest
//
//  Created by Jan Verrept on 02/10/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import SwiftUI
import WeatherKit
import JVWeather
import JVNetworking

// Struct specifier needed because compiler can't keep module LeafDriver apart from the Class with the same name
import struct LeafDriver.LeafSettingsView


struct PreferencesView: View {
	
		var body: some View {
			TabView {
				GeneralSettingsView()
					.tabItem {
						Label("General", systemImage: "gearshape")
					}
				JVNetworking.MQTTClientSettingsView()
					.tabItem {
						Label("MQTT", systemImage: "info.bubble")
					}
				TizenSettingsView()
					.tabItem {
						Label("Samsung Tizen", systemImage: "tv")
					}
				LeafDriver.LeafSettingsView()
					.tabItem {
						Label("Nissan Leaf", systemImage: "bolt.car")
					}
				WeatherService.CreditsView()
					.tabItem {
						Label("WeatherKit", systemImage: "cloud.sun.rain")
					}
				SunnyPortalSettingsView()
					.tabItem {
						Label("SunnyPortal", systemImage: "sun.max")
					}
			}
			.padding()
			.frame(minWidth: 250, maxWidth: 500, minHeight: 200, maxHeight: 400)
		}
}

#Preview {
        PreferencesView()
}
