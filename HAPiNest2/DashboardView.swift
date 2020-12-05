//
//  ContentView.swift
//  testviewx
//
//  Created by Jan Verrept on 04/12/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import SwiftUI
import YASDIDriver
import SoftPLC
import JVCocoa

struct DashBoardView: View {
    @State var showResetPairingsButton = HomeKitServer.shared.mainBridge.isPaired
    //    @State var inverterViewVisible = (SMAInverter.OnlineInverters.count > 0)
    let updateTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        TabView {
            
            ServerView(showResetPairingsButton:true)
                .tabItem {
                    Text("HomeKit Server")
                }
            
            //            if (inverterViewVisible){
            SMAInverter.OnlineInverters.first?.display.frame(width: nil, height: 120, alignment: .center)
                .tabItem {
                    Text("Solar panels")
                }
            //            }
            
//            ((NSApplication.shared.delegate) as! AppDelegate).plc.controlPanel
                .tabItem {
                    Text("PLC")
                }
            
        }
//        .onReceive(updateTimer) { _ in
//            self.showResetPairingsButton = HomeKitServer.shared.mainBridge.isPaired
//            //            self.inverterViewVisible = (SMAInverter.OnlineInverters.count > 0)
//        }
    .padding()
        
    }
}

struct DashBoardView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardView()
    }
}
