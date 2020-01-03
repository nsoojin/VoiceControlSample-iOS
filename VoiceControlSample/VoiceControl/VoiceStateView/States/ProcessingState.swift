//
//  ProcessingState.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit
import GameplayKit

class ProcessingState: VoiceState {
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        animateProcessing()
    }
    
    private func animateProcessing() {
        stateView.animationView.currentProgress = 0.16
        stateView.animationView.loopMode = .loop
        stateView.animationView.play(fromProgress: 0.16, toProgress: 0.32)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is AttendingState.Type, is ReportingState.Type:
            return true
        default:
            return false
        }
    }
}
