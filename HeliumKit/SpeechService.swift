//
//  SpeechService.swift
//  SpeakToWeather
//
//  Created by elkraneo on 26/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//


import Speech


public enum SpeechAuthorizationStatus: Int {
    case notDetermined, denied, restricted, authorized
}


public protocol SpeechServiceDelegate {
    func ready() -> Void
    func received(transcription: String) -> Void
    func recordStatusDidChange(running: Bool) -> Void
    func authorizationStatusDidChange(status: SpeechAuthorizationStatus) -> Void
    func availabilityDidChange(available: Bool) -> Void
}


public final class SpeechService: NSObject, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))! //FIXME: implemet with Locale.current
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var delegate: SpeechServiceDelegate?
    
    
    public override init() {
        super.init()
        print("💬 Speech service: started")
    }
    
    public func requestAuthorization(delegate: SpeechServiceDelegate) {
        self.delegate = delegate
        
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                guard let authStatus = SpeechAuthorizationStatus(rawValue: status.rawValue) else { return }
                delegate.authorizationStatusDidChange(status: authStatus)
            }
        }
    }
    
    func startRecording() throws {
        
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.delegate?.received(transcription: result.bestTranscription.formattedString)
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.delegate?.ready()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
    public func toggleRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            self.delegate?.recordStatusDidChange(running: false)
        } else {
            try! startRecording()
            self.delegate?.recordStatusDidChange(running: true)
        }
    }
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            delegate?.availabilityDidChange(available: true)
        } else {
            delegate?.availabilityDidChange(available: false)
        }
    }
}
