//
//  Forecast.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//

import Foundation

// https://darksky.net/dev/docs/forecast

struct Forecast {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let currently: Currently
}
