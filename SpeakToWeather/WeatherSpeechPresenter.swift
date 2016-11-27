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
            delegate.speechTextReceived(text: text)
        }
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
    
    
    init(delegate: WeatherSpeechPresenterDelegate) {
        self.delegate = delegate
        
        speechService.requestAuthorization(delegate: self)
        
        //        weatherService.load(resource: Forecast.all) { result in
        //            print(result)
        //        }
    }
    
    func checkKeywordIn(text: String) {
        var parsedText = text
        for word in keywords {
            if let index = text.range(of: word) {
                parsedText.insert(contentsOf: " [😀]".characters, at: index.upperBound)
                self.text = parsedText
            }
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
    }
    
    func received(transcription: String) {
        //print("💬 Received: \(transcription)")
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
