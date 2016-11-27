//
//  String+Words.swift
//  SpeakToWeather
//
//  Created by elkraneo on 27/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//

extension String {
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
}
