//
//  PreferencesView.swift
//  HAPiNest
//
//  Created by Jan Verrept on 02/10/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import SwiftUI
import LeafDriver
import WeatherKit
import JVWeather

struct PreferencesView: View {
	
		var body: some View {
			TabView {
				GeneralSettingsView()
					.tabItem {
						Label("General", systemImage: "gearshape")
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
