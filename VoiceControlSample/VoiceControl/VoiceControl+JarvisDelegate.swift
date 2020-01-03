//
//  VoiceControl+JarvisDelegate.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit

private let listeningStateDescription = "듣고 있어요"

extension VoiceControl: JarvisDelegate {
    func jarvis(_ jarvis: Jarvis, didChangeState state: SpeechRecognizerState) {
        switch state {
        case .preparing:
            print("attending")
            clovaAgentView?.stateView?.setState(.attending)
        case .listening:
            print("listening")
            clovaAgentView?.transcription = listeningStateDescription
            clovaAgentView?.stateView?.setState(.listening)
        case .loading:
            print("processing")
            clovaAgentView?.transcription = nil
            clovaAgentView?.stateView?.setState(.processing)
        case .speaking(let transcript):
            print("reporting")
            clovaAgentView?.transcription = nil
            clovaAgentView?.stateView?.setState(.reporting)
            clovaAgentView?.transcription = transcript
        }
    }
    
    func jarvis(_ jarvis: Jarvis, didRecognizeText text: String) {
        print("detecting")
        clovaAgentView?.stateView?.setState(.detecting)
        
        if clovaAgentView?.stateView?.state == .detecting {
            clovaAgentView?.transcription = text
        }
    }
    
    func jarvis(_ jarvis: Jarvis, didChangeAmplitude value: CGFloat) {
        clovaAgentView?.stateView?.amplify(with: Double(value))
    }
    
    func jarvis(_ jarvis: Jarvis, didFailWithError error: Error) {
        resignFirstResponder()
    }
    
    func jarvisDidEndRecognizing(_ jarvis: Jarvis) {
        clovaAgentView?.transcription = nil
        clovaAgentView?.stateView?.setState(.attending)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.resignFirstResponder()
        }
    }
}

private extension VoiceControl {
    func hasRecognizedText() -> Bool {
        if let transcription = clovaAgentView?.transcription {
            return transcription != listeningStateDescription
        }
        
        return false
    }
}
