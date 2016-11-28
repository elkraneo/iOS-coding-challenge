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
    private let keywords = ["weather", "location", "cold", "cool", "hot", "cloud", "clouds", "sun", "sunny", "outside", "gloves", "sky"]
    private var transcriptionWordList = [String]() {
        didSet {
            self.checkKeywordsInTranscription()
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
    private lazy var forecastGraphicSummary: String =  {
        self.weatherService.load(resource: Forecast.all) { result in
            guard let graphicSummary = result?.graphicSummary else { return }
            self.forecastGraphicSummary = graphicSummary
        }
        
        return "🛰"
    }()
    
    
    init(delegate: WeatherSpeechPresenterDelegate) {
        self.delegate = delegate
        
        speechService.requestAuthorization(delegate: self)
    }
    
    func checkKeywordsInTranscription() {
        for keyword in keywords {
            for (index, value) in transcriptionWordList.enumerated() {
                if value.lowercased() == keyword {
                    transcriptionWordList[index] = value.appending(" \(self.forecastGraphicSummary)")
                }
            }
        }
        
        formatTranscription()
    }
    
    func formatTranscription() {
        var formattedText = ""
        for word in transcriptionWordList {
            formattedText += word.appending(" ")
        }
        self.transcriptionFormatted = formattedText
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
        print("💬 Received: \(transcription)")
        transcriptionWordList = transcription.words()
    }
    
    func recordStatusDidChange(running: Bool) {
        if running {
            recordButtonTitle = "Stop recording"
        } else {
            recordButtonEnabled = false
            recordButtonTitle = "Stopping"
            //forecastGraphicSummary = nil
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
