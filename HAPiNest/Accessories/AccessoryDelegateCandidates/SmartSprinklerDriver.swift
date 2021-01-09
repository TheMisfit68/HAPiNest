//
//  SmartSprinklerDriver.swift
//  HAPiNest
//
//  Created by Jan Verrept on 21/10/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

//import Foundation
//import OpenWeatherReporter
//import JVCocoa
//
//
//class SmartSprinklerDriver{
//    
//    var weatherForecast24Timer:Timer! = nil
//    
//    public var enableSprinklers:Bool{
//        let twoDays:TimeInterval = 60*60*48
//        return true
//    }
//    
//    
//    init(){
//        
//        let test = OpenWeatherReporter.shared
//        updateWeatherForecast()
//        
//        let today = Date()
//        let calendar:Calendar = Calendar(identifier: .gregorian)
//        if let midnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: today){
//            weatherForecast24Timer = Timer.init(fire: midnight, interval: 86400, repeats: true, block: { timer in self.updateWeatherForecast() })
//            weatherForecast24Timer.tolerance = 60.0 // Give the processor some slack
//            weatherForecast24Timer.fire()
//        }
//        
//    }
//    
//    private func updateWeatherForecast(){
//        OpenWeatherReporter.shared.getReport(OpenWeatherReportType.twoDayHourlyReport, excludeFromReport: [.minutely, .alerts])
//    }
//    
//    
//}
