//
//  VoiceState.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit
import GameplayKit

internal class VoiceState: GKState {
    unowned let stateView: VoiceStateView
    
    init(statusView: VoiceStateView) {
        self.stateView = statusView
    }
    
    override func didEnter(from previousState: GKState?) {
        switch self {
        case is AttendingState, is ListeningState, is DetectingState:
            stateView.animationView.isHidden = true
            stateView.dotsContainerView.isHidden = false
        case is ProcessingState, is ReportingState:
            stateView.animationView.isHidden = false
            stateView.dotsContainerView.isHidden = true
        default:
            break
        }
    }
    
    override func willExit(to nextState: GKState) {
        if stateView.animationView.isAnimationPlaying {
            stateView.animationView.loopMode = .playOnce
        }
    }
}
