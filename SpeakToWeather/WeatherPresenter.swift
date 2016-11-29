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
    func speechTextReceived(text: String) -> Void
}


class WeatherPresenter: SpeechServiceDelegate, ForecastDisplayable {
    
    private let keywords = ["weather", "location", "cold", "cool", "hot", "cloud", "clouds", "sun", "sunny", "outside", "gloves", "sky", "warm", "fog", "rain", "snow", "tornado"]
    private var transcriptionWords = [String]() {
        didSet {
            self.appendForecastSummaryToKeyword()
        }
    }
    private(set) var transcriptionFormatted = "(Go ahead, press Hello Weather!)" {
        didSet {
            DispatchQueue.main.async {
                self.delegate.speechTextReceived(text: self.transcriptionFormatted)
            }
        }
    }
    private(set) var recordButtonTitle = "Hello Weather!" {
        didSet {
            self.delegate.speechStatusDidChange()
        }
    }
    private(set) var recordButtonEnabled = false {
        didSet {
            self.delegate.speechStatusDidChange()
        }
    }
    private var forecastSummary: String? {
        didSet {
            self.appendForecastSummaryToKeyword()
        }
    }
    private let delegate: WeatherSpeechPresenterDelegate
    
    
    init(delegate: WeatherSpeechPresenterDelegate) {
        self.delegate = delegate
        Helium.requestSpeechAuthorization(delegate: self)
    }
    
    /// Triggers the weather checking for current location in case of keyword detected
    func appendForecastSummaryToKeyword() {
        for keyword in keywords {
            for (index, value) in transcriptionWords.enumerated() {
                if value.lowercased() == keyword {
                    
                    if forecastSummary == nil {
                        Helium.requestForecastGraphicSummary(delegate: self)
                    }
                    
                    transcriptionWords[index] = value.appending(" \(forecastSummary ?? "🛰")")
                }
            }
        }
        
        formatTranscription()
    }
    
    func formatTranscription() {
        var formattedText = ""
        for word in transcriptionWords {
            formattedText += word.appending(" ")
        }
        self.transcriptionFormatted = formattedText
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
    
    // MARK: ForecastDisplayable
    
    func forecastSummaryDidUpdate(summary: String) {
        self.forecastSummary = summary
    }
}
