//
//  WeatherService.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//

import Foundation


typealias JSONDictionary = [String: AnyObject]

let url = URL(string: "https://api.darksky.net/forecast/")! //https://api.darksky.net/forecast/[key]/[latitude],[longitude]


class WeatherService {
    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(resource.parse(data))
            }.resume()
    }
}
