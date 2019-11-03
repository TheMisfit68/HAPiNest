//
//  ContentView.swift
//  HAPiNest
//
//  Created by Jan Verrept on 14/10/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ScrollView {
            Text("HAPiNest testing Dash 🛋")
                .padding(.top)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        
            SiriView()
            OnOfView()
            BrightnessView()
            ColorView()
            ModeView()
            
        }
        .background(Color(NSColor.darkGray))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension ContentView {
    
    struct OnOfView: View {
        var body: some View {
            VStack {
                
                Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .on, zone: .all)}) {
                    Text("All on")
                }
                
                Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .off, zone: .all)}) {
                    Text("All off")
                }
            }
        }
    }
    
    struct BrightnessView: View {
        var body: some View {
            VStack {
                Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .brightNess, value:100, zone: .all)}) {
                    Text("brightness 100 %")
                }
                Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .brightNess, value:50, zone: .all)}) {
                    Text("brightness 50 %")
                }
                Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .nightMode, zone: .all)}) {
                    Text("NightMode")
                }
                Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .temperature, value:100, zone: .all)}) {
                    Text("Cool white")
                }
                Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .temperature, value:0, zone: .all)}) {
                    Text("Warm white")
                }
            }
        }
    }
    
    struct ColorView: View {
        var body: some View {
            VStack {
               Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .hue, value:130, zone: .all)}) {
                    Text("Fixed Color")
                }
                Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .saturation, value:100, zone: .all)}) {
                    Text("Saturation 100 %")
                }
                Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .saturation, value:50, zone: .all)}) {
                    Text("Saturation 50 %")
                }
            }
        }
    }
    
    struct ModeView: View {
        var body: some View {
            VStack {
               Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .effect, value:9, zone: .all)}) {
                    Text("Mode 9")
                }
                Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .effectSpeedUp, zone: .all)}) {
                    Text("Speed effect up")
                }
                Button(action: {testDriver.executeCommand(mode: .rgbwwcw, action: .effectSpeedDown, zone: .all)}) {
                    Text("Speed effect down")
                }
            }
        }
    }
    
    struct SiriView: View {
        var body: some View {
            VStack {
                Button(action: {testSiri.speak(text: "De HAPiNest server draait prima")}) {
                    Text("Test Server")
                }
            }
        }
    }
    
}
