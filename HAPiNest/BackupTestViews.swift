//
//  TestViews.swift
//  HAPiNest
//
//  Created by Jan Verrept on 27/12/2019.
//  Copyright © 2019 Jan Verrept. All rights reserved.
//

// THE CODE BELOW IS JUST TESTCODE THAT USES THE DIFFERENT DRIVERS DIRECTLY
// WITHOUT THE USE OF HOMEKITSERVER AT ALL!!
// Its acts as a playground nothing more!

import SwiftUI
import MilightDriver
import SiriDriver
import AppleScriptDriver

let testMilight =  MilightDriverV6(ipAddress: "192.168.0.52")
let testSiri = SiriDriver(language: .flemish)
let testScripter = AppleScriptDriver()

struct TestViews: View {
    var body: some View {
     ScrollView {
              
              SiriView()
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
              
              OnOfView()
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
              
              BrightnessView()
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
              
              ColorView()
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
              
              ModeView()
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
              
              
          }
          .padding(10)
          .background(Color(NSColor.darkGray))
      }
}

struct TestViews_Previews: PreviewProvider {
    static var previews: some View {
        TestViews()
    }
}


extension TestViews {
   
   struct OnOfView: View {
       var body: some View {
           VStack {
               
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .on, zone: .all)}) {
                   Text("All on")
               }
               
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .off, zone: .all)}) {
                   Text("All off")
               }
           }
       }
   }
   
   struct BrightnessView: View {
       var body: some View {
           VStack {
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .brightNess, value:100, zone: .all)}) {
                   Text("brightness 100 %")
               }
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .brightNess, value:50, zone: .all)}) {
                   Text("brightness 50 %")
               }
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .nightMode, zone: .all)}) {
                   Text("NightMode")
               }
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .temperature, value:100, zone: .all)}) {
                   Text("Cool white")
               }
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .temperature, value:0, zone: .all)}) {
                   Text("Warm white")
               }
           }
       }
   }
   
   struct ColorView: View {
       var body: some View {
           VStack {
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .hue, value:41, zone: .all)}) {
                   Text("Fixed Color")
               }
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .saturation, value:100, zone: .all)}) {
                   Text("Saturation 100 %")
               }
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .saturation, value:50, zone: .all)}) {
                   Text("Saturation 50 %")
               }
           }
       }
   }
   
   struct ModeView: View {
       var body: some View {
           VStack {
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .effect, value:9, zone: .all)}) {
                   Text("Mode 9")
               }
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .effectSpeedUp, zone: .all)}) {
                   Text("Speed effect up")
               }
               Button(action: {testMilight.executeCommand(mode: .rgbwwcw, action: .effectSpeedDown, zone: .all)}) {
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
               
               Button(action: {testScripter.runScript("testScripter")}) {
                   Text("Run Applescript")
               }
           }
       }
   }
   
   
}
