//
//  MockJarvis.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/04.
//  Copyright © 2020 Soojin Ro. All rights reserved.
//

import Foundation
import AVFoundation

internal final class MockJarvis: Jarvis {
    weak var delegate: JarvisDelegate?
    
    func start() {
        DispatchQueue.global().async { [weak self] in
            
            self?.changeState(to: .preparing)
            usleep(0_500_000)
            
            self?.changeState(to: .listening)
            usleep(5_000_000)
            
            self?.didRecognize(text: "판교")
            self?.changeAmplitude(to: 0.8)
            usleep(1_200_000)
            
            self?.changeAmplitude(to: 0.4)
            usleep(0_400_000)
            
            self?.didRecognize(text: "판교 근처")
            self?.changeAmplitude(to: 0.9)
            usleep(1_100_000)
            
            self?.didRecognize(text: "판교 근처 카페")
            self?.changeAmplitude(to: 1.0)
            usleep(0_300_000)
            
            self?.changeAmplitude(to: 0.5)
            usleep(0_800_000)
            
            self?.didRecognize(text: "판교 근처 카페 알려줘")
            self?.changeAmplitude(to: 0.9)
            usleep(1_500_000)
            
            self?.changeAmplitude(to: 0.4)
            usleep(0_200_000)
            
            self?.changeAmplitude(to: 0.1)
            usleep(2_000_000)
            
            self?.changeState(to: .loading)
            usleep(4_000_000)
            
            let response = "판교 근처 카페를 알려드리겠습니다."
            self?.speak(response)
            self?.changeState(to: .speaking(transcript: response))
            usleep(5_000_000)
            
            self?.endRecognizing()
        }
    }
    
    func stop() {
        
    }
    
    private func changeState(to state: JarvisState) {
        DispatchQueue.main.sync {
            delegate?.jarvis(self, didChangeState: state)
        }
    }
    
    private func didRecognize(text: String) {
        DispatchQueue.main.sync {
            delegate?.jarvis(self, didRecognizeText: text)
        }
    }
    
    private func changeAmplitude(to value: CGFloat) {
        DispatchQueue.main.sync {
            delegate?.jarvis(self, didChangeAmplitude: value)
        }
    }
    
    private func endRecognizing() {
        DispatchQueue.main.sync {
            delegate?.jarvisDidEndRecognizing(self)
        }
    }
    
    private func speak(_ text: String) {
        DispatchQueue.main.async {
            print("speak \(text)")
            let synthesizer = AVSpeechSynthesizer()
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
            synthesizer.speak(utterance)
        }
    }
}
