//
//  ServerView.swift
//  HAPiNest
//
//  Created by Jan Verrept on 24/11/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import SwiftUI
import Neumorphic

struct ServerView: View {
    var body: some View {
        
        VStack {
            HapinestIconView()
            QRCodeView()
            Spacer()
        }
        
    }
}

extension ServerView{
    
    struct HapinestIconView: View {
        var body: some View {
            VStack {
                Image("DashboardImage")
                    .resizable()
                    .frame(width: 100, height: 100)
                HomekitBadgeView()
            }
        }
    }
    
    struct HomekitBadgeView: View {
        var body: some View {
            Image("HomeKitLogo").resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle()
                            .stroke(Color.gray, lineWidth: 2))
                .offset(x:50, y:-50)
                .padding(.bottom, -50)
        }
    }
    
    struct QRCodeView: View{
        @State private var showAlert: Bool = false
        var body: some View {
            VStack {
                Image(nsImage:HomeKitServer.shared.mainBridge.setupQRCode.asNSImage!)
                Text("Scan the code above using your iPhone to pair it with the")
                Text(MainConfiguration.HomeKit.BridgeName).bold().font(.system(size: 18))
                Text("(or enter setupcode \(MainConfiguration.HomeKit.BridgeSetupCode))")
                    .padding(.bottom, 15)
                Button(action: {
                    self.showAlert = true
                }) {Text("Reset all pairings")}
                .softButtonStyle(RoundedRectangle(cornerRadius: 8),padding: 8, pressedEffect: .hard)
                .alert(isPresented: $showAlert) {
                    
                    let cancelButton = Alert.Button.cancel(Text("Cancel"))
                    let actionButton = Alert.Button.default(Text("Reset")) {
                        HomeKitServer.shared.mainBridge.resetPairingInfo()
                    }
                    
                    return Alert(
                        title: Text("Are you sure?"),
                        message: Text("Reset all paired accesories?"),
                        primaryButton: cancelButton, secondaryButton: actionButton)
                }
                
                
            }.multilineTextAlignment(.center)
        }
    }
    
}

// MARK: - Previews
struct ServerView_Previews: PreviewProvider {
    static var previews: some View {
        ServerView()
    }
}
