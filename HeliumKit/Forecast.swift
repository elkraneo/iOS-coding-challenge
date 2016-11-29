//
//  Forecast.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//
//  https://darksky.net/dev/docs/forecast


private let darkSkyAPIKey = "d984b6b110ddbdc3e99363676241d039"
private let darkSkyURL = "https://api.darksky.net/forecast"
private var url: URL {
    // [url]/[key]/[latitude],[longitude]
    return URL(string: "\(darkSkyURL)/\(darkSkyAPIKey)/\( Manager.default.weatherService.locationStringParameter)")!
}


public protocol ForecastDisplayable {
    func forecastSummaryDidUpdate(summary: String) -> Void
}


public struct Forecast {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let currently: Currently?
    public var emojiedSummary: String? {
        guard let iconName = currently?.icon,
            let iconGraphic = WeatherIcon(rawValue: iconName)?.emojiDescription(),
            let temperature = currently?.temperature else { return nil }
        
        let measurement = Measurement(value: temperature, unit: UnitTemperature.fahrenheit)
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        let temperatureFormatted = formatter.string(from: measurement)
        let composedGraphicSummary = "\(iconGraphic) \(temperatureFormatted)"
        
        return composedGraphicSummary
    }
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
    
    static let current = Resource<Forecast>(url: url, parseJSON: { json in
        guard let dictionary = json as? JSONDictionary else { return nil }
        
        return Forecast(dictionary: dictionary)
    })
}
