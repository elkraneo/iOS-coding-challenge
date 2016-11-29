//
//  WeatherService.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//


public typealias JSONDictionary = [String: Any]


public final class WeatherService {
    
    private(set) public var locationStringParameter = "0,0" // [latitude],[longitude]
    
    
    public init() {
        print("🌤 Weather service: started")
    }
    
    public func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(resource.parse(data))
            }.resume()
    }
    
    public func update(locationStringParameter: String) {
        self.locationStringParameter = locationStringParameter
    }
}
