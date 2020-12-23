//
//  ContentView.swift
//  testviewx
//
//  Created by Jan Verrept on 04/12/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import SwiftUI
import Neumorphic
import YASDIDriver
import SoftPLC
import JVCocoa

struct DashBoardView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
//    @State var showResetPairingsButton = HomeKitServer.shared.mainBridge.isPaired
//      @State var inverterViewVisible = (SMAInverter.OnlineInverters.count > 0)
    
    var body: some View {
        Neumorphic.shared.colorScheme = colorScheme
        return TabView {
            
            ServerView()
                .tabItem {
                    Text("HomeKit Server")
                }
            
            //            if (inverterViewVisible){
            SMAInverter.OnlineInverters.first?.display.frame(width: nil, height: 120, alignment: .center)
                .tabItem {
                    Text("Solar panels")
                }
            //            }
            
            AppState.shared.plc.controlPanel
                .tabItem {
                    Text("PLC")
                }.background(Neumorphic.shared.mainColor())

        
        }
        .padding()
        .background(Neumorphic.shared.mainColor())
    }
    
}


// MARK: - Previews
struct DashBoardView_Previews: PreviewProvider {

    static var previews: some View {
        
        Group {
            DashBoardView()
              .environment(\.colorScheme, .light)

            DashBoardView()
              .environment(\.colorScheme, .dark)

        }
    }
}
