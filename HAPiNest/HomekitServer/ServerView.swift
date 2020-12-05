//
//  ServerView.swift
//  HAPiNest
//
//  Created by Jan Verrept on 24/11/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import SwiftUI

struct ServerView: View {
    var showResetPairingsButton: Bool
    var body: some View {
        VStack {
            HapinestIconView()
            QRCodeView(showResetPairingsButton:showResetPairingsButton)
            Spacer()
        }
    }
    
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
        var showResetPairingsButton: Bool
        var body: some View {
            VStack {
                Image(nsImage:HomeKitServer.shared.mainBridge.setupQRCode.asNSImage!)
                Text("Scan the code above using your iPhone to pair it with the")
                Text(MainConfiguration.HomeKit.BridgeName).bold().font(.system(size: 18))
                Text("(or enter setupcode \(MainConfiguration.HomeKit.BridgeSetupCode))")
                //                    if showResetPairingsButton {
                Button(action: {
                    HomeKitServer.shared.mainBridge.resetPairingInfo()
                }) {Text("Reset all pairings")}
                //                    }
                
            }.multilineTextAlignment(.center)
        }
    }
    
}


//struct ServerView_Previews: PreviewProvider {
//    var test: Bool = true
//    static var previews: some View {
//        ServerView(showResetPairingsButton: test)
//    }
//}
