//
//  String+Words.swift
//  SpeakToWeather
//
//  Created by elkraneo on 27/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//

public extension String {
    func words() -> [String] {
        let range = Range<String.Index>(uncheckedBounds: (lower: self.startIndex, upper: self.endIndex))
        var words = [String]()
        
        self.enumerateSubstrings(in: range, options: .byWords) { (substring, _, _, _) -> () in
            if let word = substring {
                words.append(word)
            }
        }
        
        return words
    }
    
    func ranges(of aString: String) -> [Range<String.Index>] {
        let range = Range<String.Index>(uncheckedBounds: (lower: self.startIndex, upper: self.endIndex))
        var ranges = [Range<String.Index>]()
        
        self.enumerateSubstrings(in: range, options: .byWords) { (substring, _, upperRange, _) in
            if substring == aString {
                ranges.append(upperRange)
            }
        }
        
        return ranges
    }
}
