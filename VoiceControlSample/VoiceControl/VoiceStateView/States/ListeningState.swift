//
//  ListeningState.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit
import GameplayKit

internal final class ListeningState: VoiceState {
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        animateBounce()
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        removeAnimation()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is AttendingState.Type, is DetectingState.Type:
            return true
        default:
            return false
        }
    }
    
    private func animateBounce() {
        stateView.dots.forEach(bounce(_:))
    }
    
    private func bounce(_ dot: UIView) {
        let delayTime = 0.2 * Double(dot.tag-1)
        
        let bounce = CAKeyframeAnimation(keyPath: "position.y")
        bounce.beginTime = CACurrentMediaTime() + delayTime
        bounce.values = [0, -6, 0, 6, 0]
        bounce.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        bounce.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut),
                                 CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn),
                                 CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut),
                                 CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)]
        bounce.duration = 1.0
        bounce.isAdditive = true
        bounce.repeatCount = .infinity
        dot.layer.add(bounce, forKey: ListeningState.animationKey)
    }
    
    private func removeAnimation() {
        stateView.dots.forEach { $0.layer.removeAnimation(forKey: ListeningState.animationKey) }
    }
    
    private static let animationKey: String = "BounceAnimationKey"
}
