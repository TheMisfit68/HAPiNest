//
//  WeatherReporter.swift
//  HAPiNest
//
//  Created by Jan Verrept on 26/09/2023.
//  Copyright © 2023 Jan Verrept. All rights reserved.
//

import Foundation
import WeatherKit
import CoreLocation
import OSLog

class WeatherReporter:NSObject, CLLocationManagerDelegate{
    
    let mininumPrecipitationLimit:Double
    let hotTemperatureLimit:Double
    
    var locationManager = CLLocationManager()
    var thisLocation:CLLocation?
    
    let calendar = Calendar.current
    let daysInPast:Int
    let daysInFuture:Int
    let pastRange:Range<Int>
    let todayRange:ClosedRange<Int>
    let futureRange:ClosedRange<Int>
    let updateInterval:TimeInterval
    let timeOutInterval:TimeInterval
    var previousUpdate:Date? = nil
    var needsUpdating:Bool{
        
        let now = Date()
        
        if let weatherDate = weather?.currentWeather.date{
            return ( now >= (weatherDate+updateInterval) )
        }else if let previousUpdate = self.previousUpdate {
            self.previousUpdate = now
            return ( now >= (previousUpdate+timeOutInterval) )
        }else{
            self.previousUpdate = now
            return true
        }
        
    }
    
    let weatherService = WeatherService()
    var weather:(currentWeather:CurrentWeather, DayWeather:Forecast<DayWeather>, HourWeather:Forecast<HourWeather>)?
    
    
    init(daysInPast:Int = 2, daysInFuture:Int = 3, whitUpdateInterval updateInterval: TimeInterval = TimeInterval(3600)){
        
        self.mininumPrecipitationLimit = 10.0   // Unit for my current location = mm
        self.hotTemperatureLimit = 25.0         // Unit for my current location = °C
        
        self.daysInPast = daysInPast
        self.daysInFuture = daysInFuture
        
        pastRange = 0..<daysInPast
        todayRange = daysInPast...daysInPast
        futureRange = daysInPast+1...daysInPast+daysInFuture
        
        self.updateInterval = updateInterval
        self.timeOutInterval = TimeInterval(10)
    }
    
    
    var wasDry:Bool{
        guard weather != nil else {return false}
        return weather!.DayWeather[pastRange].allSatisfy({
            let lowPercipitationAmount = ($0.precipitationAmount.value <= mininumPrecipitationLimit)
            let highMaxTemperature = ($0.highTemperature.value >= hotTemperatureLimit)
            return lowPercipitationAmount && highMaxTemperature
        })
    }
    
    var isDry:Bool{
        guard weather != nil else {return false}
        return weather!.DayWeather[todayRange].allSatisfy({
            let lowPercipitationAmount = ($0.precipitationAmount.value <= mininumPrecipitationLimit)
            let hotTemperature = ($0.highTemperature.value >= hotTemperatureLimit)
            return lowPercipitationAmount && hotTemperature
        })
        
    }
    
    var willBeDry:Bool{
        guard weather != nil else {return false}
        return weather!.DayWeather[futureRange].allSatisfy({
            let lowPercipitationAmount = ($0.precipitationAmount.value <= mininumPrecipitationLimit)
            let hotTemperature = ($0.highTemperature.value >= hotTemperatureLimit)
            return lowPercipitationAmount && hotTemperature
        })
    }
    
    var isWindy:Bool{
        guard weather != nil else {return false}
        return weather!.currentWeather.condition == WeatherCondition.windy
    }
    
    public func updateWeather()async{
        guard thisLocation != nil else {determineLocation(); return}
        if needsUpdating{
            
            let firstDay:Date = Date()-(Double(daysInPast)*24*3600)
            let lastDay:Date = Date()+(Double(daysInFuture)*24*3600)
            weather = try? await weatherService.weather(for: thisLocation!,
                                                        including: .current,
                                                        .daily(startDate: firstDay, endDate: lastDay),
                                                        .hourly(startDate: firstDay, endDate: lastDay)
            )
#warning("DEBUGPRINT") // TODO: - remove temp print statement
            print("🐞\t\(weather?.DayWeather[0])")
            
            
        }
    }
    
    private func determineLocation(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
    }
    
}

// MARK: - CLLocationManagerDelegate
extension WeatherReporter{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        thisLocation = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        let logger = Logger(subsystem: "be.oneclick.HAPiNest", category:"WeatherReporter")
        logger.error("\(error.localizedDescription)")
    }
    
}






