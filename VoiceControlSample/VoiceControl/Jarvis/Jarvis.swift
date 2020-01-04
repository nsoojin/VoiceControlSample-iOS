//
//  SpeechRecognizer.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import Foundation

internal protocol Jarvis {
    var delegate: JarvisDelegate? { get set }
    func start()
    func stop()
}
