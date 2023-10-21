//
//  GeneralSettingsView.swift
//  HAPiNest
//
//  Created by Jan Verrept on 02/10/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import SwiftUI

struct GeneralSettingsView: View {
	@AppStorage("showPreview") private var showPreview = true
	@AppStorage("fontSize") private var fontSize = 12.0
	
	var body: some View {
        Text("Hello, World!")
	}
}

#Preview {
    GeneralSettingsView()
}
