//
//  SpeechRecognizerDelegate.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit

internal protocol JarvisDelegate: AnyObject {
    func jarvis(_ jarvis: Jarvis, didChangeState state: SpeechRecognizerState)
    func jarvis(_ jarvis: Jarvis, didRecognizeText text: String)
    func jarvis(_ jarvis: Jarvis, didChangeAmplitude value: CGFloat)
    func jarvis(_ jarvis: Jarvis, didFailWithError error: Error)
    func jarvisDidEndRecognizing(_ jarvis: Jarvis)
}
