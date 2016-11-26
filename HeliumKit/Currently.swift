//
//  Currently.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//


struct Currently {
    let time: Int
    let summary: String
    let icon: String //FIXME: change for enum
    let nearestStormDistance: Int
    let precipIntensity: Double
    let precipIntensityError: Double
    let precipProbability: Double
    let precipType: String //FIXME: change for enum
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let windSpeed: Double
    let windBearing: Int
    let visibility: Double
    let cloudCover: Double
    let pressure: Double
    let ozone: Double
}

extension Currently {
    init?(dictionary: JSONDictionary) {
        guard let time = dictionary["time"] as? Int,
            let summary = dictionary["summary"] as? String,
            let icon = dictionary["icon"] as? String,
            let nearestStormDistance = dictionary["nearestStormDistance"] as? Int,
            let precipIntensity = dictionary["precipIntensity"] as? Double,
            let precipIntensityError = dictionary["precipIntensityError"] as? Double,
            let precipProbability = dictionary["precipProbability"] as? Double,
            let precipType = dictionary["precipType"] as? String,
            let temperature = dictionary["temperature"] as? Double,
            let apparentTemperature = dictionary["apparentTemperature"] as? Double,
            let dewPoint = dictionary["dewPoint"] as? Double,
            let humidity = dictionary["humidity"] as? Double,
            let windSpeed = dictionary["windSpeed"] as? Double,
            let windBearing = dictionary["windBearing"] as? Int,
            let visibility = dictionary["visibility"] as? Double,
            let cloudCover = dictionary["cloudCover"] as? Double,
            let pressure = dictionary["pressure"] as? Double,
            let ozone = dictionary["ozone"] as? Double else { return nil }
        
        self.time = time
        self.summary = summary
        self.icon = icon
        self.nearestStormDistance = nearestStormDistance
        self.precipIntensity = precipIntensity
        self.precipIntensityError = precipIntensityError
        self.precipProbability = precipProbability
        self.precipType = precipType
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.dewPoint = dewPoint
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windBearing = windBearing
        self.visibility = visibility
        self.cloudCover = cloudCover
        self.pressure = pressure
        self.ozone = ozone
    }
}
