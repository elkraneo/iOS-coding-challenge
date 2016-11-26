//
//  WeatherService.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//


public typealias JSONDictionary = [String: Any]

let darkSkyAPIKey = "d984b6b110ddbdc3e99363676241d039"
let url = URL(string: "https://api.darksky.net/forecast/\(darkSkyAPIKey)/48.121,11.563")! //https://api.darksky.net/forecast/[key]/[latitude],[longitude]


public final class WeatherService {
    public func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(resource.parse(data))
            }.resume()
    }
    
    public init() {
        print("💬 WeatherService started with APIKey: \(darkSkyAPIKey)")
    }
}
