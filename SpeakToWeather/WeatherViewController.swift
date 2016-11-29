//
//  WeatherPresenterViewController.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//


import UIKit


class WeatherViewController: UIViewController, WeatherSpeechPresenterDelegate {
    
    @IBOutlet var textView : UITextView!
    @IBOutlet var recordButton: UIButton!
    
    private var presenter: WeatherPresenter!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.presenter = WeatherPresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.isEnabled = presenter.recordButtonEnabled
        textView.text = presenter.transcriptionFormatted
    }
    
    // MARK: Interface Builder actions
    
    @IBAction func recordButtonTapped() {
       presenter.toggleRecording()
    }
    
    // MARK: WeatherSpeechPresenterDelegate
    
    func speechStatusDidChange() {
        recordButton.isEnabled = presenter.recordButtonEnabled
        recordButton.setTitle(presenter.recordButtonTitle, for: recordButton.isEnabled ? [] : .disabled)
    }
    
    func speechTextReceived() {
        textView.text = presenter.transcriptionFormatted
    }
}
