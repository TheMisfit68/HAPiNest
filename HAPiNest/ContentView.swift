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
                HomekitLogoView()
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
    
    struct QRCodeView: View {
        var body: some View {
            VStack {
                Image(nsImage:HomeKitServer.shared.bridge.setupQRCode.asNSImage!)
                Text("Scan this QR code using your iPhone to pair with the\n\(bridgeName)\n(or enter setupcode \(bridgeSetupCode))").multilineTextAlignment(.center)
            }
        }
    }
    
    struct HomekitLogoView: View {
        var body: some View {
                Image("HomeKitLogo").resizable().frame(width: 100, height: 100)
        }
    }
    
}

