//
//  ContentView.swift
//  HAPiNest
//
//  Created by Jan Verrept on 27/12/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                HapinestIconView()
                Spacer()
                QRCodeView()
            }
        }
        .padding(20)
        .frame(width: 450, height: 300, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
    
    struct QRCodeView: View {
        var body: some View {
            VStack {
                Image(nsImage:HomeKitServer.shared.bridge.setupQRCode.asNSImage!)
                Text("Scan the code above using your iPhone to pair it with the")
                Text(bridgeName).bold().font(.system(size: 18))
                Text("(or enter setupcode \(bridgeSetupCode))")
            }.multilineTextAlignment(.center)
        }
    }
    
    
}

