//
//  WeatherPresenter.swift
//  SpeakToWeather
//
//  Created by elkraneo on 27/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//


import HeliumKit


protocol WeatherSpeechPresenterDelegate {
    func speechStatusDidChange() -> Void
    func speechTextReceived() -> Void
    func locationStatusDidChange() -> Void
}


class WeatherPresenter: SpeechServiceDelegate, LocationServiceDelegate, ForecastDisplayable {
    
    private let defaultMessage = "(Go ahead, press Hello Weather!)"
    private let keywords = ["weather", "location", "cold", "cool", "hot", "cloud", "clouds", "sun", "sunny", "outside", "gloves", "sky", "warm", "fog", "rain", "snow", "tornado"]
    private var transcriptionWords = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.delegate.speechTextReceived()
            }
        }
    }
    var transcriptionFormatted: String {
        guard !transcriptionWords.isEmpty else { return defaultMessage }
        
        var formattedText = ""
        for word in transcriptionWords {
            formattedText += word.appending(" ")
        }
        
        return formattedText
    }
    private(set) var recordButtonTitle = "Hello Weather!" {
        didSet {
            delegate.speechStatusDidChange()
        }
    }
    private(set) var recordButtonEnabled = false {
        didSet {
            delegate.speechStatusDidChange()
        }
    }
    private var forecastSummary: String?
    private let delegate: WeatherSpeechPresenterDelegate
    private(set) var locationStatusMessage: String? {
        didSet {
            delegate.locationStatusDidChange()
        }
    }
    
    init(delegate: WeatherSpeechPresenterDelegate) {
        self.delegate = delegate
        Helium.requestSpeechAuthorization(delegate: self)
        Helium.requestLocationAuthorization(delegate: self)
    }
    
    /// Triggers the weather checking for current location in case of keyword detected
    private func appendForecastSummaryToKeyword() {
        for keyword in keywords {
            for (index, value) in transcriptionWords.enumerated() {
                let receivingEmoji = "🛰"
                let formattedKeyword = value.replacingOccurrences(of: "[\(receivingEmoji)]", with: "").lowercased()
                
                if formattedKeyword == keyword {
                    
                    if forecastSummary == nil {
                        Helium.requestForecastGraphicSummary(delegate: self)
                    }
                    
                    transcriptionWords[index] = formattedKeyword.appending("[\(forecastSummary ?? receivingEmoji)]")
                }
            }
        }
    }
    
    func toggleRecording() {
        Helium.speechToggleRecording()
    }
    
    // MARK: SpeechServiceDelegate
    
    func ready() {
        print("💬 Speech ready")
        recordButtonEnabled = true
        recordButtonTitle = "Hello Weather!"
    }
    
    func received(transcription: String) {
        print("💬 : \(transcription)")
        transcriptionWords = transcription.words()
        appendForecastSummaryToKeyword()
    }
    
    func recordStatusDidChange(running: Bool) {
        if running {
            Helium.startUpdatingLocation()
            recordButtonTitle = "Stop recording"
        } else {
            Helium.stopUpdatingLocation()
            recordButtonEnabled = false
            recordButtonTitle = "Stopping"
        }
    }
    
    func authorizationStatusDidChange(status: SpeechAuthorizationStatus) {
        print("💬 Speech service \(status)")
        switch status {
        case .authorized:
            recordButtonEnabled = true
            
        case .denied:
            recordButtonEnabled = false
            recordButtonTitle = "User denied access to speech recognition"
            
        case .restricted:
            recordButtonEnabled = false
            recordButtonTitle = "Speech recognition restricted on this device"
            
        case .notDetermined:
            recordButtonEnabled = false
            recordButtonTitle = "Speech recognition not yet authorized"
        }
    }
    
    func availabilityDidChange(available: Bool) {
        print("💬 Speech service\(available ? "" : " not") available")
        if available {
            recordButtonEnabled = true
            recordButtonTitle = "Hello Weather!"
        } else {
            recordButtonEnabled = false
            recordButtonTitle = "Recognition not available"
        }
    }
    
    // MARK: LocationServiceDelegate
    
    func authorizationStatusDidChange(status: LocationAuthorizationStatus) {
        print("🌍 Location service \(status)")
        switch status {
        case .notDetermined:
            locationStatusMessage = "Location not yet authorized"
        case .restricted:
            locationStatusMessage = "Location restricted on this device"
        case .denied:
            locationStatusMessage = "User denied access to Location"
        default:
            locationStatusMessage = defaultMessage
        }
    }
    
    // MARK: ForecastDisplayable
    
    func forecastSummaryDidUpdate(summary: String) {
        forecastSummary = summary
        appendForecastSummaryToKeyword()
    }
}
