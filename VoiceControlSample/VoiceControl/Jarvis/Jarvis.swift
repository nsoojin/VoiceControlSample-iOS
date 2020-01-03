//
//  SpeechRecognizer.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import Foundation
import AVFoundation

internal enum SpeechRecognizerState {
    case preparing
    case listening
    case loading
    case speaking(transcript: String)
}

internal final class Jarvis {
    weak var delegate: JarvisDelegate?
    
    func start() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.sync {
                self.delegate?.jarvis(self, didChangeState: .preparing)
            }
            usleep(0_500_000)
            
            DispatchQueue.main.sync {
                self.delegate?.jarvis(self, didChangeState: .listening)
            }
            usleep(5_000_000)
            
            DispatchQueue.main.sync {
                self.delegate?.jarvis(self, didRecognizeText: "판교")
                self.delegate?.jarvis(self, didChangeAmplitude: 0.8)
            }
            usleep(1_000_000)
            
            DispatchQueue.main.sync {
                self.delegate?.jarvis(self, didChangeAmplitude: 0.4)
            }
            usleep(0_200_000)
            
            DispatchQueue.main.sync {
                self.delegate?.jarvis(self, didRecognizeText: "판교 근처")
                self.delegate?.jarvis(self, didChangeAmplitude: 0.9)
            }
            usleep(0_200_000)
            
            DispatchQueue.main.sync {
                self.delegate?.jarvis(self, didRecognizeText: "판교 근처 카페")
                self.delegate?.jarvis(self, didChangeAmplitude: 1.0)
            }
            usleep(0_200_000)
            
            DispatchQueue.main.sync {
                self.delegate?.jarvis(self, didChangeAmplitude: 0.7)
            }
            usleep(0_200_000)
            
            DispatchQueue.main.sync {
                self.delegate?.jarvis(self, didRecognizeText: "판교 근처 카페 알려줘")
                self.delegate?.jarvis(self, didChangeAmplitude: 0.3)
            }
            usleep(0_200_000)
            
            DispatchQueue.main.sync {
                self.delegate?.jarvis(self, didChangeAmplitude: 0.1)
            }
            usleep(2_000_000)
            
            DispatchQueue.main.sync {
                self.delegate?.jarvis(self, didChangeState: .loading)
            }
            usleep(4_000_000)
            
            let response = "판교 근처 카페를 알려드리겠습니다."
            let synthesizer = AVSpeechSynthesizer()
            let utterance = AVSpeechUtterance(string: response)
            utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
            synthesizer.speak(utterance)
            
            DispatchQueue.main.sync {
                self.delegate?.jarvis(self, didChangeState: .speaking(transcript: response))
            }
            usleep(5_000_000)
            
            DispatchQueue.main.sync {
                self.delegate?.jarvisDidEndRecognizing(self)
            }
        }
    }
    
    func stop() {
        
    }
}
