//
//  Forecast.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//
//  https://darksky.net/dev/docs/forecast


public struct Forecast {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let currently: Currently?
}


extension Forecast {
    init?(dictionary: JSONDictionary) {
        do {
            guard let latitude = try dictionary.getValue(for: "latitude", as: Double()),
                let longitude = try dictionary.getValue(for: "longitude", as: Double()),
                let timezone = try dictionary.getValue(for: "timezone", as: String()) else { return nil }
            
            self.latitude = latitude
            self.longitude = longitude
            self.timezone = timezone
            
            guard let currently = try dictionary.getValue(for: "currently", as: JSONDictionary()) else { return nil }
            
            self.currently = Currently(dictionary: currently)
        }
        catch {
            return nil
        }
    }
}


public extension Forecast {
    static let all = Resource<Forecast>(url: url, parseJSON: { json in
        guard let dictionary = json as? JSONDictionary else { return nil }
        
        return Forecast(dictionary: dictionary)
    })
}
