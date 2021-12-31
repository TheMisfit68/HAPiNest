//
//  DashboardPreview.swift
//  HAPiNest
//
//  Created by Jan Verrept on 30/12/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//

import SwiftUI
import SoftPLC

extension DashboardView {
	
	public static let preview = DashboardView(
		serverView: HomeKitServerView.preview,
		plcView: SoftPLCView.preview
	)
	
}
