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
    private let keywords = ["weather", "cold", "hot", "cloud", "sunny"]
    private(set) var text = "(Go ahead, press Hello Weather!)" {
        didSet {
            DispatchQueue.main.async {
                self.delegate.speechTextReceived(text: self.text)
            }
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
    
    func checkKeywordIn(text: String) {
        for word in keywords {
            guard let index = text.range(of: word) else { return }
            
            insertWeather(to: text, at: index.upperBound, withCompletion: { (parsedText) in
                self.text = parsedText
            })
        }
    }
    
    func insertWeather(to text: String, at index: String.Index, withCompletion completion: @escaping (String)->()) {
        var parsedText = text
        
        //Use cached forecast for this session if available
        if let _ = forecastGraphicSummary {
            parsedText.insert(contentsOf: " [\(self.forecastGraphicSummary ?? "❌")]".characters, at: index)
            completion(parsedText)
            return
        }
        
        weatherService.load(resource: Forecast.all) { result in
            self.forecastGraphicSummary = result?.graphicSummary
            parsedText.insert(contentsOf: " [\(self.forecastGraphicSummary ?? "❌")]".characters, at: index)
            completion(parsedText)
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
        text = transcription
        checkKeywordIn(text: transcription)
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
