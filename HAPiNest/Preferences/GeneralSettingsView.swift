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
		Form {
			Toggle("Show Previews", isOn: $showPreview)
			Slider(value: $fontSize, in: 9...96) {
				Text("Font Size (\(fontSize, specifier: "%.0f") pts)")
			}
		}
		.padding(20)
		.frame(width: 350, height: 100)
	}
}

struct GeneralSettingsView_Previews: PreviewProvider {
	static var previews: some View {
		GeneralSettingsView()
	}
}
