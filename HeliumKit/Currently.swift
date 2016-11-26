//
//  Currently.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//

import Foundation

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
