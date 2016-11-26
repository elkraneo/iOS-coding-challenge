//
//  ViewController.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//

import UIKit
import HeliumKit

class ViewController: UIViewController, SpeechServiceDelegate {
    
    @IBOutlet var textView : UITextView!
    @IBOutlet weak var recordButton: UIButton!
    
    private var weatherService: WeatherService?
    private var speechService: SpeechService?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        weatherService = WeatherService()
        speechService = SpeechService(delegate: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable the record buttons until authorization has been granted.
        recordButton.isEnabled = false
        textView.text = "(Go ahead, press Hello Weather!)"
    }
    
    // MARK: SpeechServiceDelegate
    
    func ready() {
        print("Speech ready.")
        recordButton.isEnabled = true
        recordButton.setTitle("Hello Weather!", for: [])
        
        weatherService?.load(resource: Forecast.all) { result in
            print(result)
        }
    }
    
    func received(transcription: String) {
        print("💬 Received: \(transcription)")
        self.textView.text = transcription
    }
    
    func authorizationStatusDidChange(status: SpeechAuthorizationStatus) {
        print("💬 Status changed: \(status)")
        switch status {
        case .authorized:
            self.recordButton.isEnabled = true
            
        case .denied:
            self.recordButton.isEnabled = false
            self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
            
        case .restricted:
            self.recordButton.isEnabled = false
            self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
            
        case .notDetermined:
            self.recordButton.isEnabled = false
            self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
        }
    }
    
    func availabilityDidChange(available: Bool) {
        print("💬 Availability changed: \(available)")
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Hello Weather!", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    func recordStatusDidChange(status: SpeechRecordStatus) {
        switch status {
        case .notRunning:
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
        case .running:
            recordButton.setTitle("Stop recording", for: [])
        }
    }
    
    // MARK: Interface Builder actions
    
    @IBAction func recordButtonTapped() {
        speechService?.toggleRecording()
    }
}
