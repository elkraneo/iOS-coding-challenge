//
//  Helium.swift
//  SpeakToWeather
//
//  Created by Cristian Díaz on 28/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//

import Foundation


public struct Helium {
    static public func requestForecastGraphicSummary(delegate: ForecastDisplayable) {
        guard let location = Manager.default.locationService.lastLocation else { return }
        
        Manager.default.weatherService.update(locationStringParameter: "\(location.latitude),\(location.longitude)")
        Manager.default.weatherService.load(resource: Forecast.all) { (forecast) in
            guard let emojiedSummary = forecast?.emojiedSummary else { return }
            delegate.forecastSummaryDidUpdate(summary: emojiedSummary)
        }
    }
    
    //  MARK: Location
    
    static public func requestLocationAuthorization(delegate: LocationServiceDelegate) {
        Manager.default.locationService.requestAuthorization(delegate: delegate)
    }
    
    static public func startUpdatingLocation() {
        Manager.default.locationService.startUpdatingLocation()
    }
    
    static public func stopUpdatingLocation() {
        Manager.default.locationService.stopUpdatingLocation()
    }
    
    //  MARK: Speech
    
    static public func requestSpeechAuthorization(delegate: SpeechServiceDelegate) {
        Manager.default.speechService.requestAuthorization(delegate: delegate)
    }
    
    static public func speechToggleRecording() {
        Manager.default.speechService.toggleRecording()
    }
}
