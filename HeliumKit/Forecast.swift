//
//  Forecast.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//
//  https://darksky.net/dev/docs/forecast


struct Forecast {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let currently: Currently
}

extension Forecast {
    init?(dictionary: JSONDictionary) {
        guard let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double,
            let timezone = dictionary["timezone"] as? String,
            let currently = dictionary["currently"] as? Currently else { return nil }
        
        self.latitude = latitude
        self.longitude = longitude
        self.timezone = timezone
        self.currently = currently
    }
}

extension Forecast {
    static let all = Resource<[Forecast]>(url: url, parseJSON: { json in
        guard let dictionaries = json as? [JSONDictionary] else { return nil }
        return dictionaries.flatMap(Forecast.init)
    })
}
