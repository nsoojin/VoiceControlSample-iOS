//
//  ReportingState.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit
import GameplayKit

internal final class ReportingState: VoiceState {
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        animateReporting()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is AttendingState.Type:
            return true
        default:
            return false
        }
    }
    
    private func animateReporting() {
        stateView.animationView.currentProgress = 0.32
        stateView.animationView.loopMode = .loop
        stateView.animationView.play(fromProgress: 0.32, toProgress: 0.52)
    }
}
