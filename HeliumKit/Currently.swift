//
//  Currently.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//


struct Currently {
    let time: Int
    let summary: String?
    let icon: String? //FIXME: change for enum
    let nearestStormDistance: Double?
    let precipIntensity: Double?
    let precipIntensityError: Double?
    let precipProbability: Double?
    let precipType: String? //FIXME: change for enum
    let temperature: Double?
    let apparentTemperature: Double?
    let dewPoint: Double?
    let humidity: Double?
    let windSpeed: Double?
    let windBearing: Int?
    let visibility: Double?
    let cloudCover: Double?
    let pressure: Double?
    let ozone: Double?
}


enum WeatherIcon: String {
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case rain = "rain"
    case snow = "snow"
    case sleet = "sleet"
    case wind = "wind"
    case fog = "fog"
    case cloudy = "cloudy"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    
    public func emojiDescription() -> String {
        switch self {
        case .clearDay:
            return "☀️"
        case .clearNight:
            return "🌌"
        case .rain:
            return "☔️"
        case .snow:
            return "❄️"
        case .sleet:
            return "🌨"
        case .wind:
            return "💨"
        case .fog:
            return "🌫"
        case .cloudy:
            return "☁️"
        case .partlyCloudyDay:
            return "⛅️"
        case .partlyCloudyNight:
            return "☁️🌃"
        }
    }
}


extension Currently {
    init?(dictionary: JSONDictionary) {
        do {
            guard let time = try dictionary.getValue(for: "time", as: Int()) else { return nil }
            
            self.time = time
            self.summary = try dictionary.getValue(for: "summary", as: String())
            self.icon = try dictionary.getValue(for: "icon", as: String())
            self.nearestStormDistance = try dictionary.getValue(for: "nearestStormDistance", as: Double())
            self.precipIntensity = try dictionary.getValue(for: "precipIntensity", as: Double())
            self.precipIntensityError = try dictionary.getValue(for: "precipIntensityError", as: Double())
            self.precipProbability = try dictionary.getValue(for: "precipProbability", as: Double())
            self.precipType = try dictionary.getValue(for: "precipType", as: String())
            self.temperature = try dictionary.getValue(for: "temperature", as: Double())
            self.apparentTemperature = try dictionary.getValue(for: "apparentTemperature", as: Double())
            self.dewPoint = try dictionary.getValue(for: "dewPoint", as: Double())
            self.humidity = try dictionary.getValue(for: "humidity", as: Double())
            self.windSpeed = try dictionary.getValue(for: "windSpeed", as: Double())
            self.windBearing = try dictionary.getValue(for: "windBearing", as: Int())
            self.visibility = try dictionary.getValue(for: "visibility", as: Double())
            self.cloudCover = try dictionary.getValue(for: "cloudCover", as: Double())
            self.pressure = try dictionary.getValue(for: "pressure", as: Double())
            self.ozone = try dictionary.getValue(for: "ozone", as: Double())
        }
        catch {
            return nil
        }
    }
}
