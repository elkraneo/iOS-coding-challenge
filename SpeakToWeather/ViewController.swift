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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        WeatherService().load(resource: Forecast.all) { result in
            print(result)
        }
        
        try! SpeechService(delegate: self).startRecording()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: SpeechServiceDelegate

    func ready() {
        print("Speech ready.")
    }
    
    func received(transcription: String) {
        print("💬 Received: \(transcription)")
    }
    
    func authorizationStatusDidChange(status: SpeechAuthorizationStatus) {
        print("💬 Status changed: \(status)")
    }
    
    func availabilityDidChange(available: Bool) {
        print("💬 Availability changed: \(available)")
    }

}
