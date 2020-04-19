//
//  ContentView.swift
//  HAPiNest
//
//  Created by Jan Verrept on 27/12/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import SwiftUI
import JVCocoa
import YASDIDriver

struct ContentView: View {
    @State var showResetPairingsButton = HomeKitServer.shared.bridge.isPaired
    @State var inverterViewVisible = (SMAInverter.OnlineInverters.count > 0)
    let updateTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            VStack {
                HapinestIconView()
                Spacer()
                QRCodeView(showResetPairingsButton:$showResetPairingsButton)
                if (inverterViewVisible){
                    SMAInverter.OnlineInverters.first?.display.frame(width: nil, height: 120, alignment: .center)
                }
                Spacer()
            }
        }
        .padding(20)
        .onReceive(updateTimer) { _ in
            self.showResetPairingsButton = HomeKitServer.shared.bridge.isPaired
            print("\(self.showResetPairingsButton)")
            self.inverterViewVisible = (SMAInverter.OnlineInverters.count > 0)
        }
    }
}

extension ContentView {
    
    struct HapinestIconView: View {
        var body: some View {
            VStack {
                Image("DashboardImage").resizable().frame(width: 100, height: 100)
                HomekitBadgeView()
            }
        }
    }
    
    struct HomekitBadgeView: View {
        var body: some View {
            Image("HomeKitLogo").resizable().frame(width: 40, height: 40).clipShape(Circle()).overlay(
                Circle().stroke(Color.gray, lineWidth: 2)).offset(x:50, y:-50).padding(.bottom, -50)
        }
    }
    
    struct QRCodeView: View{
        @Binding var showResetPairingsButton: Bool
        var body: some View {
            VStack {
                Image(nsImage:HomeKitServer.shared.bridge.setupQRCode.asNSImage!)
                Text("Scan the code above using your iPhone to pair it with the")
                Text(bridgeName).bold().font(.system(size: 18))
                Text("(or enter setupcode \(bridgeSetupCode))")
                if showResetPairingsButton {
                    Button(action: {
                        HomeKitServer.shared.resetPairingInfo()
                        self.showResetPairingsButton = false
                    }) {Text("Reset all pairings")}
                }
                
            }.multilineTextAlignment(.center)
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("DumyPreview")
    }
}
