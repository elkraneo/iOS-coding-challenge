//
//  JSONSubscripting.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//


enum JSONError: Error {
    case emptyJSONData, invalidJSONData
}

extension Dictionary {
    func getValue<T>(for key: Key, as _: T) throws -> T? {
        guard let _ = self[key] else { return nil }
        guard let value = self[key] as? T else { throw JSONError.invalidJSONData }
        
        return value
    }
}
