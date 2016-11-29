//
//  Manager.swift
//  SpeakToWeather
//
//  Created by Cristian Díaz on 29/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//


import Foundation


public struct Configuration {
    let weatherService = WeatherService()
    let speechService = SpeechService()
    let locationService = LocationService()
}


open class Manager {
    
    /// A default instance of `Manager`, used by top-level Helium request methods
    open static let `default`: Manager = {
        let configuration = Configuration()
        
        return Manager(configuration: configuration)
    }()
    
    public init(configuration: Configuration = Configuration()) {
        self.weatherService = configuration.weatherService
        self.speechService = configuration.speechService
        self.locationService = configuration.locationService
    }
    
    /// The underlying WeatherService session.
    open let weatherService: WeatherService
    
    /// The underlying trakt session.
    open let speechService: SpeechService
    
    /// The underlying OperationQueue.
    open let locationService: LocationService
}
