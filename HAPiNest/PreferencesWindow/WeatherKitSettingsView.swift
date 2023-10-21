//
//  OpenWeatherSettingsView.swift
//  HAPiNest
//
//  Created by Jan Verrept on 02/10/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import SwiftUI
import OSLog
import WeatherKit

struct WeatherKitSettingsView: View {
    
    var body: some View {
        WeatherService.CreditsView()
    }

}

#Preview {
    WeatherKitSettingsView()
}
