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


class WeatherSpeechPresenter: SpeechServiceDelegate {
    
    private let weatherService = WeatherService()
    private let speechService = SpeechService()
    private let delegate: WeatherSpeechPresenterDelegate
    private let keywords = ["weather", "cold", "cool", "hot", "cloud", "sunny"]
    private(set) var transcriptionFormatted = "(Go ahead, press Hello Weather!)" {
        didSet {
            DispatchQueue.main.async {
                self.delegate.speechTextReceived(text: self.transcriptionFormatted)
            }
        }
    }
    private var transcription = [String]() {
        didSet {
            var formattedText: String
            for word in transcription {
                formattedText += word
            }
            self.transcriptionFormatted = formattedText
        }
    }
    private(set) var recordButtonTitle = "Hello Weather!" {
        didSet {
            DispatchQueue.main.async {
                self.delegate.speechStatusDidChange()
            }
        }
    }
    private(set) var recordButtonEnabled = false {
        didSet {
            DispatchQueue.main.async {
                self.delegate.speechStatusDidChange()
            }
        }
    }
    private(set) var forecastGraphicSummary: String?
    
    
    init(delegate: WeatherSpeechPresenterDelegate) {
        self.delegate = delegate
        
        speechService.requestAuthorization(delegate: self)
    }
    
    func checkKeywordsInTranscription() {
        for word in keywords {
            //guard let _ = transcriptionOriginal.range(of: word) else { return }
            
            for index in transcriptionOriginal.ranges(of: word) {
                insertWeather(at: index.upperBound)
            }
        }
    }
    
    func insertWeather(at index: String.Index) {
        //Use cached forecast for this session if available
        if let _ = forecastGraphicSummary {
            transcriptionFormatted.insert(contentsOf: "\(self.forecastGraphicSummary ?? "❌") ".characters, at: index)
            return
        }
        
        weatherService.load(resource: Forecast.all) { result in
            self.forecastGraphicSummary = result?.graphicSummary
            self.transcriptionFormatted.insert(contentsOf: "\(self.forecastGraphicSummary ?? "❌") ".characters, at: index)
        }
    }
    
    func toggleRecording() {
        speechService.toggleRecording()
    }
    
    // MARK: SpeechServiceDelegate
    
    func ready() {
        print("💬 Speech ready.")
        recordButtonEnabled = true
        recordButtonTitle = "Hello Weather!"
        forecastGraphicSummary = nil
    }
    
    func received(transcription: String) {
        print("💬 Received: \(transcription)")
        self.transcriptionOriginal = transcription
        checkKeywordsInTranscription()
    }
    
    func recordStatusDidChange(running: Bool) {
        if running {
            recordButtonEnabled = false
            recordButtonTitle = "Stopping"
        } else {
            recordButtonTitle = "Stop recording"
        }
    }
    
    func authorizationStatusDidChange(status: SpeechAuthorizationStatus) {
        print("💬 Status changed: \(status)")
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
        print("💬 Availability changed: \(available)")
        if available {
            recordButtonEnabled = true
            recordButtonTitle = "Hello Weather!"
        } else {
            recordButtonEnabled = false
            recordButtonTitle = "Recognition not available"
        }
    }
}
